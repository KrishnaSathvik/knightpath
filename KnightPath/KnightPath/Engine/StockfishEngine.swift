import Foundation
import ChessKit
import ChessKitEngine

/// Concrete implementation of UCI engine using ChessKitEngine's Stockfish wrapper
actor StockfishEngine {
    private var engine: Engine?
    private var isInitialized = false
    
    init() {}
    
    func start() async throws {
        guard !isInitialized else { return }
        
        engine = Engine(type: .stockfish)
        
        await engine?.send(command: .uci)
        await engine?.send(command: .isready)
        
        isInitialized = true
    }
    
    func stop() async {
        engine = nil
        isInitialized = false
    }
    
    func newGame() async throws {
        guard isInitialized else {
            throw EngineError.notRunning
        }
        
        await engine?.send(command: .ucinewgame)
        await engine?.send(command: .isready)
    }
    
    func analyze(
        position: Position,
        multiPV: Int = 1,
        depth: Int = 15,
        moveTime: Int = 1000
    ) async throws -> [UCICandidate] {
        guard isInitialized, let engine = engine else {
            throw EngineError.notRunning
        }
        
        await engine.send(command: .setoption(id: "MultiPV", value: "\(multiPV)"))
        await engine.send(command: .setoption(id: "Skill Level", value: "20"))
        
        let fen = position.fen
        await engine.send(command: .position(fen: fen))
        
        let timeout = TimeInterval(moveTime) * 3 / 1000
        
        return try await withTimeout(seconds: timeout) {
            await engine.send(command: .go(depth: depth, moveTime: moveTime))
            
            var candidates: [UCICandidate] = []
            var receivedBestMove = false
            
            for await response in engine.stream {
                switch response {
                case .info(let details):
                    if let pvIndex = details.multiPV,
                       let score = details.score,
                       let pv = details.pv,
                       let firstMove = pv.first {
                        
                        let from = String(firstMove.prefix(2))
                        let to = String(firstMove.dropFirst(2).prefix(2))
                        let centipawns: Int
                        
                        switch score {
                        case .cp(let value):
                            centipawns = value
                        case .mate(let moves):
                            centipawns = moves > 0 ? 10000 : -10000
                        }
                        
                        let candidate = UCICandidate(
                            multiPVIndex: pvIndex,
                            from: from,
                            to: to,
                            centipawns: centipawns,
                            depth: details.depth ?? 0
                        )
                        
                        if let existingIndex = candidates.firstIndex(where: { $0.multiPVIndex == pvIndex }) {
                            candidates[existingIndex] = candidate
                        } else {
                            candidates.append(candidate)
                        }
                    }
                    
                case .bestMove:
                    receivedBestMove = true
                    return candidates.sorted { $0.multiPVIndex < $1.multiPVIndex }
                    
                default:
                    continue
                }
            }
            
            if !receivedBestMove && !candidates.isEmpty {
                return candidates.sorted { $0.multiPVIndex < $1.multiPVIndex }
            }
            
            throw EngineError.timeout
        }
    }
    
    func getBestMove(
        position: Position,
        skillLevel: Int = 20,
        moveTime: Int = 1000
    ) async throws -> Move? {
        await engine?.send(command: .setoption(id: "Skill Level", value: "\(skillLevel)"))
        
        let candidates = try await analyze(position: position, multiPV: 1, moveTime: moveTime)
        guard let best = candidates.first else { return nil }
        
        return position.legalMoves.first { move in
            move.start.description == best.from && move.end.description == best.to
        }
    }
    
    private func withTimeout<T>(seconds: TimeInterval, operation: @escaping () async throws -> T) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }
            
            group.addTask {
                try await Task.sleep(for: .seconds(seconds))
                throw EngineError.timeout
            }
            
            let result = try await group.next()!
            group.cancelAll()
            return result
        }
    }
}
