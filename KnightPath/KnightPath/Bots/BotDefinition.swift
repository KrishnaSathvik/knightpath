import Foundation
import ChessKit

struct BotDefinition: Identifiable {
    let id: String
    let name: String
    let persona: String
    let skillLevel: Int
    let moveTimeRange: ClosedRange<Int>
    let multiPV: Int
    let scorer: (UCICandidate, Position) -> Double
    let temperature: Double
    let thinkingDelay: ClosedRange<Double>
    
    let weaknessHint: String
    let difficultyTier: Int
    
    let startTaunts: [String]
    let captureTaunts: [String]
    let checkTaunts: [String]
    let winTaunts: [String]
    let loseTaunts: [String]
    
    init(
        id: String,
        name: String,
        persona: String,
        skillLevel: Int,
        moveTimeRange: ClosedRange<Int>,
        multiPV: Int = 3,
        temperature: Double = 1.0,
        thinkingDelay: ClosedRange<Double> = 0.5...2.0,
        weaknessHint: String,
        difficultyTier: Int,
        startTaunts: [String] = [],
        captureTaunts: [String] = [],
        checkTaunts: [String] = [],
        winTaunts: [String] = [],
        loseTaunts: [String] = [],
        scorer: @escaping (UCICandidate, Position) -> Double
    ) {
        self.id = id
        self.name = name
        self.persona = persona
        self.skillLevel = skillLevel
        self.moveTimeRange = moveTimeRange
        self.multiPV = multiPV
        self.temperature = temperature
        self.thinkingDelay = thinkingDelay
        self.weaknessHint = weaknessHint
        self.difficultyTier = difficultyTier
        self.startTaunts = startTaunts
        self.captureTaunts = captureTaunts
        self.checkTaunts = checkTaunts
        self.winTaunts = winTaunts
        self.loseTaunts = loseTaunts
        self.scorer = scorer
    }
    
    func selectMove(from candidates: [UCICandidate], position: Position) -> UCICandidate? {
        guard !candidates.isEmpty else { return nil }
        
        let scoredCandidates = candidates.map { candidate in
            (candidate: candidate, score: scorer(candidate, position))
        }
        
        return softmaxSample(scoredCandidates, temperature: temperature)
    }
    
    private func softmaxSample(_ scoredCandidates: [(candidate: UCICandidate, score: Double)], temperature: Double) -> UCICandidate? {
        let expScores = scoredCandidates.map { exp($0.score / temperature) }
        let sumExp = expScores.reduce(0, +)
        
        guard sumExp > 0 else { return scoredCandidates.first?.candidate }
        
        let probabilities = expScores.map { $0 / sumExp }
        
        let random = Double.random(in: 0..<1)
        var cumulative = 0.0
        
        for (index, probability) in probabilities.enumerated() {
            cumulative += probability
            if random < cumulative {
                return scoredCandidates[index].candidate
            }
        }
        
        return scoredCandidates.last?.candidate
    }
    
    func randomTaunt(for event: TauntEvent) -> String? {
        let taunts: [String]
        switch event {
        case .gameStart: taunts = startTaunts
        case .capture: taunts = captureTaunts
        case .check: taunts = checkTaunts
        case .win: taunts = winTaunts
        case .lose: taunts = loseTaunts
        }
        return taunts.randomElement()
    }
}

enum TauntEvent {
    case gameStart
    case capture
    case check
    case win
    case lose
}
