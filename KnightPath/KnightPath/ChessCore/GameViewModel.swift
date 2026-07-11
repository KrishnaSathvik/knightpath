import Foundation
import ChessKit

@Observable
final class GameViewModel {
    private(set) var gameState: GameState
    private(set) var phase: GamePhase = .playing
    
    private(set) var selectedSquare: Square?
    private(set) var legalMoves: [Square] = []
    private(set) var lastMove: (from: Square, to: Square)?
    
    private(set) var capturedPieces: (white: [Piece], black: [Piece]) = ([], [])
    
    init() {
        self.gameState = GameState()
    }
    
    init(fen: String) {
        self.gameState = GameState(fen: fen)
    }
    
    func selectSquare(_ square: Square) {
        guard phase == .playing else { return }
        
        if let selected = selectedSquare {
            if selected == square {
                deselectSquare()
            } else if legalMoves.contains(square) {
                attemptMove(from: selected, to: square)
            } else if let piece = gameState.piece(at: square),
                      piece.color == (gameState.currentPlayer == .white ? .white : .black) {
                selectedSquare = square
                legalMoves = gameState.legalMoves(from: square)
                HapticsService.shared.move()
            } else {
                deselectSquare()
            }
        } else {
            if let piece = gameState.piece(at: square),
               piece.color == (gameState.currentPlayer == .white ? .white : .black) {
                selectedSquare = square
                legalMoves = gameState.legalMoves(from: square)
                HapticsService.shared.move()
            }
        }
    }
    
    func deselectSquare() {
        selectedSquare = nil
        legalMoves = []
    }
    
    func attemptMove(from: Square, to: Square) {
        guard phase == .playing else { return }
        
        if gameState.needsPromotion(from: from, to: to) {
            phase = .promotion(square: to.description, availablePieces: ["queen", "rook", "bishop", "knight"])
            selectedSquare = from
            return
        }
        
        do {
            let wasCapture = gameState.piece(at: to) != nil
            try gameState.makeMove(from: from, to: to)
            
            lastMove = (from, to)
            deselectSquare()
            
            if wasCapture {
                HapticsService.shared.capture()
                SoundService.shared.capture()
                updateCapturedPieces()
            } else {
                HapticsService.shared.move()
                SoundService.shared.move()
            }
            
            checkGameState()
        } catch {
            deselectSquare()
        }
    }
    
    func promoteTopiece(_ kind: Piece.Kind) {
        guard case .promotion(let squareStr, _) = phase,
              let selected = selectedSquare,
              let targetSquare = Square(squareStr) else {
            return
        }
        
        do {
            try gameState.makeMove(from: selected, to: targetSquare, promotion: kind)
            lastMove = (selected, targetSquare)
            phase = .playing
            deselectSquare()
            
            HapticsService.shared.move()
            SoundService.shared.move()
            checkGameState()
        } catch {
            phase = .playing
            deselectSquare()
        }
    }
    
    func resign() {
        let winner = gameState.currentPlayer.opposite
        phase = .over(result: .resignation(winner: winner))
        HapticsService.shared.checkmate()
        SoundService.shared.victory()
    }
    
    func reset() {
        gameState.reset()
        phase = .playing
        selectedSquare = nil
        legalMoves = []
        lastMove = nil
        capturedPieces = ([], [])
    }
    
    private func checkGameState() {
        if gameState.isCheckmate {
            let winner = gameState.currentPlayer.opposite
            phase = .over(result: .checkmate(winner: winner))
            HapticsService.shared.checkmate()
            SoundService.shared.victory()
        } else if gameState.isStalemate {
            phase = .over(result: .stalemate)
            HapticsService.shared.checkmate()
        } else if gameState.isCheck {
            HapticsService.shared.check()
            SoundService.shared.check()
        }
    }
    
    private func updateCapturedPieces() {
        var whiteCaptured: [Piece] = []
        var blackCaptured: [Piece] = []
        
        let allSquares = Square.all
        let currentPieces = allSquares.compactMap { gameState.piece(at: $0) }
        
        let startingCounts: [Piece.Kind: Int] = [
            .pawn: 8, .knight: 2, .bishop: 2, .rook: 2, .queen: 1, .king: 1
        ]
        
        for color in [Color.white, Color.black] {
            for kind in [Piece.Kind.pawn, .knight, .bishop, .rook, .queen] {
                let currentCount = currentPieces.filter { $0.kind == kind && $0.color == color }.count
                let captured = (startingCounts[kind] ?? 0) - currentCount
                for _ in 0..<captured {
                    let piece = Piece(kind: kind, color: color)
                    if color == .white {
                        whiteCaptured.append(piece)
                    } else {
                        blackCaptured.append(piece)
                    }
                }
            }
        }
        
        capturedPieces = (whiteCaptured, blackCaptured)
    }
}
