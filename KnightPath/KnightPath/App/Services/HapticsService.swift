import UIKit

final class HapticsService {
    static let shared = HapticsService()
    
    private var isEnabled: Bool = true
    
    private init() {}
    
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    func move() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func capture() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func check() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func checkmate() {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        }
    }
    
    func tick() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred(intensity: 0.5)
    }
    
    func rigid() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
}
