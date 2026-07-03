import Foundation

struct RewardCalculator {
    enum GameType {
        case pathBotMatch(tier: Int, isReplay: Bool)
        case passAndPlay
        case puzzle
        case drill
        case trophy
        case practiceMode
    }
    
    struct Rewards {
        let xp: Int
        let coins: Int
        let stars: Int
        let badges: [String]
    }
    
    static func calculateRewards(
        gameType: GameType,
        result: GameResult,
        accuracy: Double,
        hintsUsed: Int,
        playerColor: PieceColor,
        isFirstWinOfDay: Bool = false
    ) -> Rewards {
        var xp = 0
        var coins = 0
        var stars = 0
        var badges: [String] = []
        
        switch gameType {
        case .pathBotMatch(let tier, let isReplay):
            if case .checkmate(let winner) = result, winner == playerColor {
                if isReplay {
                    xp = 20
                    coins = 15
                } else {
                    xp = 100 * tier
                    coins = 50 * tier
                    stars = 1
                    
                    if accuracy >= 0.85 && hintsUsed == 0 {
                        stars = 3
                        xp += 50
                        coins += 25
                    } else if accuracy >= 0.75 {
                        stars = 2
                        xp += 25
                        coins += 10
                    }
                    
                    if hintsUsed == 0 {
                        xp += 25
                        coins += 10
                    }
                    
                    if accuracy >= 0.85 {
                        xp += 50
                        coins += 25
                    }
                }
            } else {
                xp = 25 * tier
                coins = 10
            }
            
        case .passAndPlay:
            xp = 15
            coins = 5
            
        case .puzzle:
            xp = 10
            coins = 5
            
        case .drill:
            if case .checkmate(let winner) = result, winner == playerColor {
                xp = 30
                coins = 20
            }
            
        case .trophy:
            if case .checkmate(let winner) = result, winner == playerColor {
                xp = 150
                coins = 100
                badges.append("chapter-complete")
            }
            
        case .practiceMode:
            xp = 0
            coins = 0
        }
        
        if isFirstWinOfDay, xp > 0 {
            xp += 50
            coins += 25
        }
        
        return Rewards(xp: xp, coins: coins, stars: stars, badges: badges)
    }
    
    static func calculateStars(accuracy: Double, hintsUsed: Int) -> Int {
        if hintsUsed > 0 {
            return min(2, accuracy >= 0.75 ? 2 : 1)
        }
        
        if accuracy >= 0.85 {
            return 3
        } else if accuracy >= 0.75 {
            return 2
        } else {
            return 1
        }
    }
}
