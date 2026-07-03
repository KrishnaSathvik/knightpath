import Foundation
import ChessKit

@Observable
final class BotGameViewModel {
    private(set) var gameViewModel: GameViewModel
    private(set) var bot: BotDefinition
    private(set) var playerColor: PieceColor
    
    private(set) var isThinking = false
    private(set) var currentTaunt: String?
    
    let hintSystem: HintSystem
    private let accuracyTracker: AccuracyTracker
    
    private var engine: UCIEngine?
    private var botTask: Task<Void, Never>?
    
    init(bot: BotDefinition, playerColor: PieceColor = .white) {
        self.bot = bot
        self.playerColor = playerColor
        self.gameViewModel = GameViewModel()
        self.hintSystem = HintSystem(maxHints: 3)
        self.accuracyTracker = AccuracyTracker()
        self.engine = UCIEngine()
        
        Task {
            try? await engine?.start()
            try? await engine?.newGame()
            
            if playerColor == .black {
                await makeBotMove()
            }
        }
    }
    
    func selectSquare(_ square: Square) {
        guard !isThinking,
              gameViewModel.phase == .playing,
              gameViewModel.gameState.currentPlayer == playerColor else {
            return
        }
        
        gameViewModel.selectSquare(square)
    }
    
    func attemptMove(from: Square, to: Square) {
        guard !isThinking else { return }
        
        let movesBefore = gameViewModel.gameState.moveHistory.count
        gameViewModel.attemptMove(from: from, to: to)
        let movesAfter = gameViewModel.gameState.moveHistory.count
        
        if movesAfter > movesBefore {
            checkForTaunt(event: .capture)
            
            Task {
                await makeBotMove()
            }
        }
    }
    
    func requestHint() async {
        guard hintSystem.canUseHint(),
              gameViewModel.phase == .playing,
              gameViewModel.gameState.currentPlayer == playerColor else {
            return
        }
        
        guard let engine = engine else { return }
        
        do {
            let candidates = try await engine.analyze(
                position: gameViewModel.gameState.position,
                multiPV: 1,
                depth: 15,
                moveTime: 1000
            )
            
            guard let best = candidates.first,
                  let fromSquare = Square(best.from),
                  let toSquare = Square(best.to) else {
                return
            }
            
            hintSystem.showHint(from: fromSquare, to: toSquare, evaluation: best.evaluation)
        } catch {
            print("Hint request failed: \(error)")
        }
    }
    
    func resign() {
        gameViewModel.resign()
        checkForTaunt(event: .win)
    }
    
    func reset() {
        botTask?.cancel()
        gameViewModel.reset()
        hintSystem.reset()
        
        Task {
            await accuracyTracker.reset()
            try? await engine?.newGame()
            
            if playerColor == .black {
                await makeBotMove()
            }
        }
    }
    
    func getAccuracy() async -> Double {
        await accuracyTracker.getAccuracy()
    }
    
    private func makeBotMove() async {
        guard case .playing = gameViewModel.phase,
              gameViewModel.gameState.currentPlayer != playerColor else {
            return
        }
        
        isThinking = true
        
        let thinkingTime = Double.random(in: bot.thinkingDelay)
        try? await Task.sleep(for: .seconds(thinkingTime))
        
        guard let engine = engine else {
            isThinking = false
            return
        }
        
        do {
            let moveTime = Int.random(in: bot.moveTimeRange)
            let candidates = try await engine.analyze(
                position: gameViewModel.gameState.position,
                multiPV: bot.multiPV,
                depth: bot.skillLevel,
                moveTime: moveTime
            )
            
            guard let selectedCandidate = bot.selectMove(
                from: candidates,
                position: gameViewModel.gameState.position
            ) else {
                isThinking = false
                return
            }
            
            if let fromSquare = Square(selectedCandidate.from),
               let toSquare = Square(selectedCandidate.to) {
                
                await MainActor.run {
                    gameViewModel.attemptMove(from: fromSquare, to: toSquare)
                }
                
                if gameViewModel.gameState.isCheck {
                    checkForTaunt(event: .check)
                }
                
                if case .over = gameViewModel.phase {
                    checkForTaunt(event: .lose)
                }
            }
        } catch {
            print("Bot move failed: \(error)")
        }
        
        isThinking = false
    }
    
    private func checkForTaunt(event: TauntEvent) {
        guard let taunt = bot.randomTaunt(for: event) else { return }
        
        currentTaunt = taunt
        
        Task {
            try? await Task.sleep(for: .seconds(3))
            await MainActor.run {
                if self.currentTaunt == taunt {
                    self.currentTaunt = nil
                }
            }
        }
    }
    
    deinit {
        botTask?.cancel()
        Task {
            await engine?.stop()
        }
    }
}
