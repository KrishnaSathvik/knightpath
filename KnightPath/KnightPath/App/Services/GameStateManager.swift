import Foundation
import ChessKit

/// Manages interrupted game recovery
final class GameStateManager {
    private static let interruptedGameKey = "interruptedGame"
    
    struct SavedGameState: Codable {
        let fen: String
        let botId: String?
        let playerColor: String
        let moveHistory: [String]
        let savedAt: Date
    }
    
    static func saveGame(position: Position, botId: String?, playerColor: PieceColor, moveHistory: [String]) {
        let state = SavedGameState(
            fen: position.fen,
            botId: botId,
            playerColor: playerColor.rawValue,
            moveHistory: moveHistory,
            savedAt: Date()
        )
        
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: interruptedGameKey)
        }
    }
    
    static func loadSavedGame() -> SavedGameState? {
        guard let data = UserDefaults.standard.data(forKey: interruptedGameKey),
              let state = try? JSONDecoder().decode(SavedGameState.self, from: data) else {
            return nil
        }
        
        // Only restore games saved within last 24 hours
        let timeElapsed = Date().timeIntervalSince(state.savedAt)
        guard timeElapsed < 24 * 60 * 60 else {
            clearSavedGame()
            return nil
        }
        
        return state
    }
    
    static func clearSavedGame() {
        UserDefaults.standard.removeObject(forKey: interruptedGameKey)
    }
}
