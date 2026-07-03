import Foundation
import SwiftData

@Model
final class PlayerProfile {
    var id: UUID
    var createdAt: Date
    
    var xp: Int
    var level: Int
    var coins: Int
    
    var currentStreak: Int
    var longestStreak: Int
    var lastPlayedDate: Date?
    
    var soundEnabled: Bool
    var hapticsEnabled: Bool
    var tauntsEnabled: Bool
    var evalBarEnabled: Bool
    
    @Relationship(deleteRule: .cascade)
    var botProgresses: [BotProgress]
    
    @Relationship(deleteRule: .cascade)
    var gameRecords: [GameRecord]
    
    @Relationship(deleteRule: .cascade)
    var puzzleProgresses: [PuzzleProgress]
    
    @Relationship(deleteRule: .cascade)
    var badges: [Badge]
    
    init() {
        self.id = UUID()
        self.createdAt = Date()
        self.xp = 0
        self.level = 1
        self.coins = 100
        self.currentStreak = 0
        self.longestStreak = 0
        self.soundEnabled = true
        self.hapticsEnabled = true
        self.tauntsEnabled = true
        self.evalBarEnabled = false
        self.botProgresses = []
        self.gameRecords = []
        self.puzzleProgresses = []
        self.badges = []
    }
    
    var nextLevelXP: Int {
        level * 100
    }
    
    var xpProgress: Double {
        Double(xp) / Double(nextLevelXP)
    }
    
    func addXP(_ amount: Int) {
        xp += amount
        
        while xp >= nextLevelXP {
            xp -= nextLevelXP
            level += 1
        }
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        guard coins >= amount else { return false }
        coins -= amount
        return true
    }
}

@Model
final class BotProgress {
    var botId: String
    var stars: Int
    var bestAccuracy: Double
    var gamesPlayed: Int
    var wins: Int
    var losses: Int
    var isUnlocked: Bool
    var unlockedAt: Date?
    
    @Relationship(inverse: \PlayerProfile.botProgresses)
    var profile: PlayerProfile?
    
    init(botId: String) {
        self.botId = botId
        self.stars = 0
        self.bestAccuracy = 0.0
        self.gamesPlayed = 0
        self.wins = 0
        self.losses = 0
        self.isUnlocked = botId == "ryan"
        self.unlockedAt = botId == "ryan" ? Date() : nil
    }
}

@Model
final class GameRecord {
    var id: UUID
    var date: Date
    var botId: String?
    var playerColor: String
    var result: String
    var accuracy: Double
    var hintsUsed: Int
    var moveCount: Int
    var durationSeconds: Int
    
    @Relationship(inverse: \PlayerProfile.gameRecords)
    var profile: PlayerProfile?
    
    init(
        botId: String?,
        playerColor: PieceColor,
        result: GameResult,
        accuracy: Double,
        hintsUsed: Int,
        moveCount: Int,
        durationSeconds: Int
    ) {
        self.id = UUID()
        self.date = Date()
        self.botId = botId
        self.playerColor = playerColor.rawValue
        self.result = resultString(result)
        self.accuracy = accuracy
        self.hintsUsed = hintsUsed
        self.moveCount = moveCount
        self.durationSeconds = durationSeconds
    }
}

private func resultString(_ result: GameResult) -> String {
    switch result {
    case .checkmate(let winner):
        return "checkmate_\(winner.rawValue)"
    case .stalemate:
        return "stalemate"
    case .draw:
        return "draw"
    case .resignation(let winner):
        return "resignation_\(winner.rawValue)"
    }
}

@Model
final class PuzzleProgress {
    var date: Date
    var puzzlesSolved: Int
    var perfectDays: Int
    var currentStreakFreezes: Int
    
    @Relationship(inverse: \PlayerProfile.puzzleProgresses)
    var profile: PlayerProfile?
    
    init() {
        self.date = Date()
        self.puzzlesSolved = 0
        self.perfectDays = 0
        self.currentStreakFreezes = 0
    }
}

@Model
final class Badge {
    var id: String
    var name: String
    var earnedAt: Date
    
    @Relationship(inverse: \PlayerProfile.badges)
    var profile: PlayerProfile?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.earnedAt = Date()
    }
}
