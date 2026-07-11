import Foundation
import ChessKit

actor UCIEngine {
    enum State {
        case idle
        case analyzing
        case error(String)
    }
    
    private(set) var state: State = .idle
    private var engineProcess: Process?
    private var inputPipe: Pipe?
    private var outputPipe: Pipe?
    private var watchdogTask: Task<Void, Never>?
    
    private var pendingCallback: ((UCIResponse) -> Void)?
    private var analysisResults: [UCICandidate] = []
    
    init() {}
    
    func start() async throws {
        guard state == .idle else { return }
        
        engineProcess = Process()
        inputPipe = Pipe()
        outputPipe = Pipe()
        
        engineProcess?.standardInput = inputPipe
        engineProcess?.standardOutput = outputPipe
        
        outputPipe?.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty else { return }
            if let output = String(data: data, encoding: .utf8) {
                Task { [weak self] in
                    await self?.handleEngineOutput(output)
                }
            }
        }
        
        try engineProcess?.run()
        
        try await sendCommand("uci")
        try await sendCommand("isready")
    }
    
    func stop() async {
        watchdogTask?.cancel()
        engineProcess?.terminate()
        engineProcess = nil
        state = .idle
    }
    
    func newGame() async throws {
        try await sendCommand("ucinewgame")
        try await sendCommand("isready")
    }
    
    func analyze(
        position: Position,
        multiPV: Int = 1,
        depth: Int = 15,
        moveTime: Int = 1000
    ) async throws -> [UCICandidate] {
        guard state == .idle else {
            throw EngineError.busy
        }
        
        state = .analyzing
        analysisResults = []
        
        let fen = position.fen
        try await sendCommand("position fen \(fen)")
        try await sendCommand("setoption name MultiPV value \(multiPV)")
        try await sendCommand("go depth \(depth) movetime \(moveTime)")
        
        startWatchdog(timeout: TimeInterval(moveTime) * 3 / 1000)
        
        return await withCheckedContinuation { continuation in
            pendingCallback = { response in
                if case .bestMove = response {
                    continuation.resume(returning: self.analysisResults)
                }
            }
        }
    }
    
    func getBestMove(
        position: Position,
        skillLevel: Int = 20,
        moveTime: Int = 1000
    ) async throws -> Move? {
        try await sendCommand("setoption name Skill Level value \(skillLevel)")
        let candidates = try await analyze(position: position, multiPV: 1, moveTime: moveTime)
        guard let best = candidates.first else { return nil }
        
        return position.legalMoves.first { move in
            move.start.description == best.from && move.end.description == best.to
        }
    }
    
    private func sendCommand(_ command: String) async throws {
        guard let inputPipe = inputPipe else {
            throw EngineError.notRunning
        }
        
        let data = (command + "\n").data(using: .utf8)!
        try inputPipe.fileHandleForWriting.write(contentsOf: data)
    }
    
    private func handleEngineOutput(_ output: String) {
        let lines = output.split(separator: "\n")
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmed.hasPrefix("info") {
                parseInfoLine(trimmed)
            } else if trimmed.hasPrefix("bestmove") {
                parseBestMove(trimmed)
            }
        }
    }
    
    private func parseInfoLine(_ line: String) {
        let parts = line.split(separator: " ")
        
        guard let pvIndex = parts.firstIndex(of: "multipv"),
              pvIndex + 1 < parts.count,
              let multiPVNumber = Int(parts[pvIndex + 1]),
              let scoreIndex = parts.firstIndex(of: "cp"),
              scoreIndex + 1 < parts.count,
              let cpScore = Int(parts[scoreIndex + 1]),
              let pvMoveIndex = parts.firstIndex(of: "pv"),
              pvMoveIndex + 1 < parts.count else {
            return
        }
        
        let moveStr = String(parts[pvMoveIndex + 1])
        guard moveStr.count >= 4 else { return }
        
        let from = String(moveStr.prefix(2))
        let to = String(moveStr.dropFirst(2).prefix(2))
        
        let candidate = UCICandidate(
            multiPVIndex: multiPVNumber,
            from: from,
            to: to,
            centipawns: cpScore,
            depth: 0
        )
        
        if let existingIndex = analysisResults.firstIndex(where: { $0.multiPVIndex == multiPVNumber }) {
            analysisResults[existingIndex] = candidate
        } else {
            analysisResults.append(candidate)
        }
    }
    
    private func parseBestMove(_ line: String) {
        watchdogTask?.cancel()
        state = .idle
        
        pendingCallback?(.bestMove)
        pendingCallback = nil
    }
    
    private func startWatchdog(timeout: TimeInterval) {
        watchdogTask?.cancel()
        
        watchdogTask = Task {
            try? await Task.sleep(for: .seconds(timeout))
            
            guard !Task.isCancelled else { return }
            
            if analysisResults.isEmpty {
                state = .error("Engine watchdog timeout")
            }
            
            pendingCallback?(.bestMove)
            pendingCallback = nil
            state = .idle
        }
    }
}

struct UCICandidate: Identifiable {
    let id = UUID()
    let multiPVIndex: Int
    let from: String
    let to: String
    let centipawns: Int
    let depth: Int
    
    var evaluation: Double {
        Double(centipawns) / 100.0
    }
}

enum UCIResponse {
    case bestMove
    case info([UCICandidate])
}

enum EngineError: Error {
    case notRunning
    case busy
    case timeout
    case invalidResponse
}
