import Foundation
import ChessKit

@Observable
final class HintSystem {
    private(set) var currentHint: Hint?
    private(set) var hintsUsed: Int = 0
    private(set) var hintsAvailable: Int
    
    let maxHints: Int
    
    struct Hint {
        let from: Square
        let to: Square
        let evaluation: Double
    }
    
    init(maxHints: Int = 3) {
        self.maxHints = maxHints
        self.hintsAvailable = maxHints
    }
    
    func canUseHint() -> Bool {
        hintsAvailable > 0
    }
    
    func showHint(from: Square, to: Square, evaluation: Double) {
        guard canUseHint() else { return }
        
        currentHint = Hint(from: from, to: to, evaluation: evaluation)
        hintsUsed += 1
        hintsAvailable -= 1
        
        HapticsService.shared.move()
    }
    
    func clearHint() {
        currentHint = nil
    }
    
    func reset() {
        currentHint = nil
        hintsUsed = 0
        hintsAvailable = maxHints
    }
}
