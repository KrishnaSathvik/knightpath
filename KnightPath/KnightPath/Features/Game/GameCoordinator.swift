import SwiftUI
import SwiftData

@Observable
final class GameCoordinator {
    private(set) var showPostGame = false
    private(set) var postGameData: PostGameData?
    
    let modelContext: ModelContext
    
    struct PostGameData {
        let result: GameResult
        let playerColor: PieceColor
        let botName: String?
        let accuracy: Double
        let stars: Int
        let rewards: RewardCalculator.Rewards
        let hintsUsed: Int
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func endGame(
        result: GameResult,
        playerColor: PieceColor,
        botId: String?,
        accuracy: Double,
        hintsUsed: Int,
        moveCount: Int,
        durationSeconds: Int,
        tier: Int = 1
    ) {
        let rewards = RewardCalculator.calculateRewards(
            gameType: .pathBotMatch(tier: tier, isReplay: false),
            result: result,
            accuracy: accuracy,
            hintsUsed: hintsUsed,
            playerColor: playerColor
        )
        
        let gameRecord = GameRecord(
            botId: botId,
            playerColor: playerColor,
            result: result,
            accuracy: accuracy,
            hintsUsed: hintsUsed,
            moveCount: moveCount,
            durationSeconds: durationSeconds
        )
        
        if let profile = try? modelContext.fetch(FetchDescriptor<PlayerProfile>()).first {
            profile.addXP(rewards.xp)
            profile.addCoins(rewards.coins)
            profile.gameRecords.append(gameRecord)
            
            if let botId = botId,
               let botProgress = profile.botProgresses.first(where: { $0.botId == botId }) {
                botProgress.gamesPlayed += 1
                
                if case .checkmate(let winner) = result, winner == playerColor {
                    botProgress.wins += 1
                    botProgress.stars = max(botProgress.stars, rewards.stars)
                } else {
                    botProgress.losses += 1
                }
                
                botProgress.bestAccuracy = max(botProgress.bestAccuracy, accuracy)
            }
            
            try? modelContext.save()
        }
        
        postGameData = PostGameData(
            result: result,
            playerColor: playerColor,
            botName: botId.flatMap { BotRoster.bot(withId: $0)?.name },
            accuracy: accuracy,
            stars: rewards.stars,
            rewards: rewards,
            hintsUsed: hintsUsed
        )
        
        showPostGame = true
    }
    
    func dismissPostGame() {
        showPostGame = false
        postGameData = nil
    }
}
