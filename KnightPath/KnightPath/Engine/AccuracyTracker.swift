import Foundation
import ChessKit

actor AccuracyTracker {
    private var moveAnalyses: [MoveAnalysis] = []
    
    struct MoveAnalysis {
        let moveNumber: Int
        let actualMove: Move
        let actualEval: Int
        let bestMove: Move?
        let bestEval: Int
        let centipawnLoss: Int
        let classification: MoveClassification
    }
    
    enum MoveClassification {
        case brilliant
        case great
        case good
        case book
        case inaccuracy
        case mistake
        case blunder
        
        var color: String {
            switch self {
            case .brilliant, .great: return "success"
            case .good, .book: return "neutral"
            case .inaccuracy: return "warning"
            case .mistake, .blunder: return "danger"
            }
        }
    }
    
    func recordMove(
        moveNumber: Int,
        move: Move,
        engineEval: Int,
        bestMove: Move?,
        bestEval: Int
    ) {
        let centipawnLoss = bestEval - engineEval
        let classification = classifyMove(centipawnLoss: centipawnLoss)
        
        let analysis = MoveAnalysis(
            moveNumber: moveNumber,
            actualMove: move,
            actualEval: engineEval,
            bestMove: bestMove,
            bestEval: bestEval,
            centipawnLoss: centipawnLoss,
            classification: classification
        )
        
        moveAnalyses.append(analysis)
    }
    
    func getAccuracy() -> Double {
        guard !moveAnalyses.isEmpty else { return 0.0 }
        
        let totalCPL = moveAnalyses.reduce(0) { $0 + $1.centipawnLoss }
        let averageCPL = Double(totalCPL) / Double(moveAnalyses.count)
        
        return cpLossToAccuracy(averageCPL)
    }
    
    func getBestMove() -> MoveAnalysis? {
        moveAnalyses.min { $0.centipawnLoss < $1.centipawnLoss }
    }
    
    func getWorstMove() -> MoveAnalysis? {
        moveAnalyses.max { $0.centipawnLoss < $1.centipawnLoss }
    }
    
    func getMoveAnalyses() -> [MoveAnalysis] {
        moveAnalyses
    }
    
    func reset() {
        moveAnalyses.removeAll()
    }
    
    private func classifyMove(centipawnLoss: Int) -> MoveClassification {
        switch centipawnLoss {
        case ..<(-50):
            return .brilliant
        case ..<0:
            return .great
        case 0...25:
            return .good
        case 26...50:
            return .inaccuracy
        case 51...100:
            return .mistake
        default:
            return .blunder
        }
    }
    
    private func cpLossToAccuracy(_ avgCPLoss: Double) -> Double {
        let accuracy = 103.1668 * exp(-0.04354 * avgCPLoss) - 3.1669
        return max(0, min(100, accuracy)) / 100.0
    }
}
