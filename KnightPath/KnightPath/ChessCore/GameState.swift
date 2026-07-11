import Foundation
import ChessKit

@Observable
final class GameState {
    private(set) var position: Position
    private(set) var moveHistory: [Move] = []
    private var undoStack: [Position] = []
    private var redoStack: [Position] = []
    
    var currentPlayer: PieceColor {
        position.sideToMove == .white ? .white : .black
    }
    
    var isCheck: Bool {
        position.isCheck
    }
    
    var isCheckmate: Bool {
        position.isCheckmate
    }
    
    var isStalemate: Bool {
        position.isStalemate
    }
    
    init() {
        self.position = Position(fen: .standard)
    }
    
    init(fen: String) {
        self.position = Position(fen: fen)
    }
    
    func legalMoves(from square: Square) -> [Square] {
        let moves = position.legalMoves.filter { $0.start == square }
        return moves.map { $0.end }
    }
    
    func canMove(from: Square, to: Square) -> Bool {
        position.legalMoves.contains { $0.start == from && $0.end == to }
    }
    
    func piece(at square: Square) -> Piece? {
        position.piece(at: square)
    }
    
    func makeMove(from: Square, to: Square, promotion: Piece.Kind? = nil) throws {
        guard let move = position.legalMoves.first(where: { $0.start == from && $0.end == to }) else {
            throw GameError.illegalMove
        }
        
        undoStack.append(position)
        redoStack.removeAll()
        
        if let promotion = promotion {
            var promotionMove = move
            promotionMove.result.piece = Piece(kind: promotion, color: currentPlayer == .white ? .white : .black)
            position.make(move: promotionMove)
        } else {
            position.make(move: move)
        }
        
        moveHistory.append(move)
    }
    
    func needsPromotion(from: Square, to: Square) -> Bool {
        guard let move = position.legalMoves.first(where: { $0.start == from && $0.end == to }) else {
            return false
        }
        
        if case .pawnPromotion = move.result {
            return true
        }
        return false
    }
    
    func undo() {
        guard let previousPosition = undoStack.popLast() else { return }
        redoStack.append(position)
        position = previousPosition
        if !moveHistory.isEmpty {
            moveHistory.removeLast()
        }
    }
    
    func redo() {
        guard let nextPosition = redoStack.popLast() else { return }
        undoStack.append(position)
        position = nextPosition
    }
    
    func reset() {
        position = Position(fen: .standard)
        moveHistory.removeAll()
        undoStack.removeAll()
        redoStack.removeAll()
    }
}

enum GameError: Error {
    case illegalMove
    case gameOver
}
