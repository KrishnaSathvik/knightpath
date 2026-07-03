import Foundation
import ChessKit

enum BotRoster {
    static let all: [BotDefinition] = [
        rookieRyan,
        fastFiona,
        greedyGreg,
        castleKing,
        gambitGwen,
        tacticTara,
        silentSofia,
        endgameEli,
        theGrandmaster
    ]
    
    static func bot(withId id: String) -> BotDefinition? {
        all.first { $0.id == id }
    }
    
    static let rookieRyan = BotDefinition(
        id: "ryan",
        name: "Rookie Ryan",
        persona: "Beginner who hangs pieces and plays impulsively",
        skillLevel: 1,
        moveTimeRange: 300...800,
        multiPV: 6,
        temperature: 1.5,
        weaknessHint: "Leaves pieces hanging",
        difficultyTier: 1,
        startTaunts: [
            "Let's see what happens!",
            "I'm ready to learn!",
            "This will be fun!"
        ],
        captureTaunts: [
            "Got one!",
            "Nice piece!",
            "Oooh shiny!"
        ],
        checkTaunts: [
            "Check!",
            "Did I do that right?",
            "Your king looks worried!"
        ],
        winTaunts: [
            "I won? I actually won!",
            "Beginner's luck!",
            "That was awesome!"
        ],
        loseTaunts: [
            "Oops, didn't see that coming...",
            "Good game!",
            "I'll do better next time!"
        ]
    ) { candidate, _ in
        var score = candidate.evaluation
        
        if Double.random(in: 0...1) < 0.4 {
            score -= 2.0
        }
        
        return score
    }
    
    static let fastFiona = BotDefinition(
        id: "fiona",
        name: "Fast Fiona",
        persona: "Blitz attacker who loves checks and captures",
        skillLevel: 7,
        moveTimeRange: 200...400,
        multiPV: 4,
        temperature: 1.2,
        weaknessHint: "Neglects defense for aggression",
        difficultyTier: 2,
        startTaunts: [
            "Speed chess is my game!",
            "Let's make this quick!",
            "No time to waste!"
        ],
        captureTaunts: [
            "Too slow!",
            "Gotcha!",
            "Keep up!"
        ],
        checkTaunts: [
            "Check! Time's ticking!",
            "Under pressure!",
            "Fast and dangerous!"
        ],
        winTaunts: [
            "Speed wins!",
            "Blitz victory!",
            "Too fast for you!"
        ],
        loseTaunts: [
            "Rushed too much...",
            "Should have slowed down",
            "Fast but not fast enough"
        ]
    ) { candidate, position in
        var score = candidate.evaluation
        
        if candidate.from.contains(where: { $0 >= "6" }) {
            score += 0.3
        }
        
        let isDefensive = candidate.from.contains(where: { $0 <= "2" })
        if isDefensive {
            score -= 0.4
        }
        
        return score
    }
    
    static let greedyGreg = BotDefinition(
        id: "greg",
        name: "Greedy Greg",
        persona: "Material hunter who can't resist captures",
        skillLevel: 5,
        moveTimeRange: 400...1000,
        multiPV: 4,
        temperature: 1.0,
        weaknessHint: "Takes poisoned material",
        difficultyTier: 2,
        startTaunts: [
            "I'll take everything!",
            "More pieces, more power!",
            "Let's see what you've got!"
        ],
        captureTaunts: [
            "Mine now!",
            "Thanks for the donation!",
            "I'll take that!"
        ],
        checkTaunts: [
            "Check, and I'm winning material!",
            "Your king's in trouble!",
            "Checkmate coming!"
        ],
        winTaunts: [
            "Greed is good!",
            "Too much material!",
            "I took it all!"
        ],
        loseTaunts: [
            "That was... poisoned...",
            "Shouldn't have been so greedy",
            "Got too hungry"
        ]
    ) { candidate, position in
        var score = candidate.evaluation
        
        if let targetSquare = Square(candidate.to),
           position.piece(at: targetSquare) != nil {
            score += 0.5
        }
        
        return score
    }
    
    static let castleKing = BotDefinition(
        id: "castle-king",
        name: "Castle King",
        persona: "Defensive player who castles early",
        skillLevel: 8,
        moveTimeRange: 500...1200,
        multiPV: 3,
        temperature: 0.8,
        weaknessHint: "Overly cautious",
        difficultyTier: 3,
        startTaunts: [
            "Safety first!",
            "My king is well protected!",
            "Defense wins games!"
        ],
        captureTaunts: [
            "A calculated risk",
            "Defense doesn't mean passive",
            "Controlled aggression"
        ],
        checkTaunts: [
            "Even defense can attack!",
            "Check from safety!",
            "Calculated pressure!"
        ],
        winTaunts: [
            "Solid defense prevails!",
            "Safety brings victory!",
            "Fortress unbreached!"
        ],
        loseTaunts: [
            "My castle wasn't enough...",
            "Defense failed",
            "Too passive"
        ]
    ) { candidate, position in
        var score = candidate.evaluation
        
        let isPawnMoveNearKing = candidate.from.contains("e") || candidate.from.contains("f") || candidate.from.contains("g")
        if isPawnMoveNearKing && candidate.from.contains("2") {
            score -= 0.3
        }
        
        return score
    }
    
    static let gambitGwen = BotDefinition(
        id: "gwen",
        name: "Gambit Gwen",
        persona: "Trickster who loves sharp positions",
        skillLevel: 9,
        moveTimeRange: 600...1400,
        multiPV: 5,
        temperature: 1.1,
        weaknessHint: "Sacrifices can backfire",
        difficultyTier: 3,
        startTaunts: [
            "Let's get creative!",
            "Expect the unexpected!",
            "Time for tricks!"
        ],
        captureTaunts: [
            "Calculated chaos!",
            "All part of the plan!",
            "Complications incoming!"
        ],
        checkTaunts: [
            "Did you see this coming?",
            "Surprise!",
            "Tactical chaos!"
        ],
        winTaunts: [
            "Tricks and tactics win!",
            "Gambits pay off!",
            "Creativity triumphs!"
        ],
        loseTaunts: [
            "Too clever for my own good...",
            "Gambit declined",
            "Tactics failed"
        ]
    ) { candidate, position in
        var score = candidate.evaluation
        
        if abs(candidate.evaluation) > 1.0 {
            score += 0.4
        }
        
        return score
    }
    
    static let tacticTara = BotDefinition(
        id: "tara",
        name: "Tactic Tara",
        persona: "Tactical genius who finds combinations",
        skillLevel: 12,
        moveTimeRange: 800...1600,
        multiPV: 4,
        temperature: 0.7,
        weaknessHint: "Can miss simple moves looking for tactics",
        difficultyTier: 4,
        startTaunts: [
            "Let's see your tactics!",
            "Combinations everywhere!",
            "Think carefully!"
        ],
        captureTaunts: [
            "Tactical precision!",
            "Combination executed!",
            "Calculated perfectly!"
        ],
        checkTaunts: [
            "Tactical check!",
            "Fork incoming!",
            "Pin and win!"
        ],
        winTaunts: [
            "Tactics triumph!",
            "Combinations win games!",
            "Calculated victory!"
        ],
        loseTaunts: [
            "Missed the tactics...",
            "Overlooked it",
            "Too focused on combinations"
        ]
    ) { candidate, position in
        var score = candidate.evaluation
        
        if abs(candidate.evaluation) > 0.5 {
            score += 0.3
        }
        
        return score
    }
    
    static let silentSofia = BotDefinition(
        id: "sofia",
        name: "Silent Sofia",
        persona: "Positional squeezer who grinds you down",
        skillLevel: 13,
        moveTimeRange: 1000...1800,
        multiPV: 3,
        temperature: 0.6,
        weaknessHint: "Can be too quiet when aggression needed",
        difficultyTier: 4,
        startTaunts: [
            "Patience wins",
            "Small advantages add up",
            "Quiet strength"
        ],
        captureTaunts: [
            "When necessary",
            "Calculated exchange",
            "Improving my position"
        ],
        checkTaunts: [
            "Quiet but deadly",
            "Pressure building",
            "Inevitable"
        ],
        winTaunts: [
            "Positional mastery",
            "Slow and steady",
            "The squeeze worked"
        ],
        loseTaunts: [
            "Too passive",
            "Needed more aggression",
            "Outplayed"
        ]
    ) { candidate, position in
        var score = candidate.evaluation
        
        if let targetSquare = Square(candidate.to),
           position.piece(at: targetSquare) != nil {
            score -= 0.2
        }
        
        if candidate.evaluation > 0 && candidate.evaluation < 0.5 {
            score += 0.3
        }
        
        return score
    }
    
    static let endgameEli = BotDefinition(
        id: "eli",
        name: "Endgame Eli",
        persona: "Endgame monster who loves to trade",
        skillLevel: 14,
        moveTimeRange: 800...1600,
        multiPV: 3,
        temperature: 0.7,
        weaknessHint: "Weaker in complex middlegames",
        difficultyTier: 5,
        startTaunts: [
            "Let's trade into the endgame",
            "I excel in simplified positions",
            "Endgame advantage"
        ],
        captureTaunts: [
            "Trading pieces!",
            "Simplifying!",
            "One step closer to the endgame!"
        ],
        checkTaunts: [
            "Endgame tactics!",
            "King and pawns!",
            "Technical precision!"
        ],
        winTaunts: [
            "Endgame mastery!",
            "Technique wins!",
            "Simplification worked!"
        ],
        loseTaunts: [
            "Didn't reach my endgame...",
            "Too complex",
            "Middlegame weakness"
        ]
    ) { candidate, position in
        var score = candidate.evaluation
        
        let moveCount = position.fullmoves
        if moveCount > 30 {
            score += 0.5
        }
        
        if let targetSquare = Square(candidate.to),
           position.piece(at: targetSquare) != nil {
            score += 0.3
        }
        
        return score
    }
    
    static let theGrandmaster = BotDefinition(
        id: "grandmaster",
        name: "The Grandmaster",
        persona: "Final boss - full strength engine",
        skillLevel: 20,
        moveTimeRange: 1500...2500,
        multiPV: 1,
        temperature: 0.3,
        weaknessHint: "Find one if you can",
        difficultyTier: 6,
        startTaunts: [
            "Let's play proper chess",
            "Show me what you've learned",
            "This will be instructive"
        ],
        captureTaunts: [
            "Inevitable",
            "Calculated",
            "Precision"
        ],
        checkTaunts: [
            "Check",
            "Your king's position is compromised",
            "Technique"
        ],
        winTaunts: [
            "Well played",
            "Better luck next time",
            "Study and return"
        ],
        loseTaunts: [
            "Impressive. You've earned this.",
            "Congratulations.",
            "You have become strong."
        ]
    ) { candidate, _ in
        candidate.evaluation
    }
}
