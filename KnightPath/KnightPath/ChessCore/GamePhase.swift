import Foundation

enum GamePhase: Equatable {
    case playing
    case promotion(square: String, availablePieces: [String])
    case over(result: GameResult)
}

enum GameResult: Equatable {
    case checkmate(winner: PieceColor)
    case stalemate
    case draw
    case resignation(winner: PieceColor)
}

enum PieceColor: String {
    case white
    case black
    
    var opposite: PieceColor {
        self == .white ? .black : .white
    }
}
