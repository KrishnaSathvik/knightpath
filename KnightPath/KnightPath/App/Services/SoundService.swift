import AVFoundation

final class SoundService {
    static let shared = SoundService()
    
    private var isEnabled: Bool = true
    private var players: [String: AVAudioPlayer] = [:]
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        if !enabled {
            stopAll()
        }
    }
    
    func move() {
        guard isEnabled else { return }
        playSound("move")
    }
    
    func capture() {
        guard isEnabled else { return }
        playSound("capture")
    }
    
    func check() {
        guard isEnabled else { return }
        playSound("check")
    }
    
    func victory() {
        guard isEnabled else { return }
        playSound("victory")
    }
    
    func puzzleSolve() {
        guard isEnabled else { return }
        playSound("puzzle")
    }
    
    private func playSound(_ name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "wav") {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.volume = 0.5
                players[name] = player
                player.play()
            } catch {
                print("Failed to play sound \(name): \(error)")
            }
        }
    }
    
    private func stopAll() {
        players.values.forEach { $0.stop() }
        players.removeAll()
    }
}
