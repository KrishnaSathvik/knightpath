import Foundation

enum NodeType {
    case bot(botId: String)
    case puzzle(theme: String, count: Int)
    case drill(id: String)
    case trophy(chapter: Int)
}

enum NodeState {
    case locked
    case available
    case inProgress
    case completed(stars: Int)
}

struct PathNode: Identifiable {
    let id: String
    let type: NodeType
    let chapter: Int
    let position: Int
    var state: NodeState
    
    var title: String {
        switch type {
        case .bot(let botId):
            return BotRoster.bot(withId: botId)?.name ?? "Bot"
        case .puzzle(let theme, _):
            return theme.capitalized
        case .drill(let id):
            return "Drill: \(id)"
        case .trophy(let chapter):
            return "Chapter \(chapter) Trophy"
        }
    }
    
    var icon: String {
        switch type {
        case .bot:
            return "person.circle"
        case .puzzle:
            return "puzzlepiece.fill"
        case .drill:
            return "stopwatch.fill"
        case .trophy:
            return "trophy.fill"
        }
    }
}

struct PathData {
    static let chapters: [[PathNode]] = [
        chapter1,
        chapter2,
        chapter3
    ]
    
    static let chapter1: [PathNode] = [
        PathNode(id: "c1-ryan", type: .bot(botId: "ryan"), chapter: 1, position: 0, state: .available),
        PathNode(id: "c1-puzzle1", type: .puzzle(theme: "forks", count: 3), chapter: 1, position: 1, state: .locked),
        PathNode(id: "c1-fiona", type: .bot(botId: "fiona"), chapter: 1, position: 2, state: .locked),
        PathNode(id: "c1-drill1", type: .drill(id: "checkmate-basic"), chapter: 1, position: 3, state: .locked),
        PathNode(id: "c1-greg", type: .bot(botId: "greg"), chapter: 1, position: 4, state: .locked),
        PathNode(id: "c1-trophy", type: .trophy(chapter: 1), chapter: 1, position: 5, state: .locked)
    ]
    
    static let chapter2: [PathNode] = [
        PathNode(id: "c2-castle", type: .bot(botId: "castle-king"), chapter: 2, position: 0, state: .locked),
        PathNode(id: "c2-puzzle1", type: .puzzle(theme: "pins", count: 3), chapter: 2, position: 1, state: .locked),
        PathNode(id: "c2-gwen", type: .bot(botId: "gwen"), chapter: 2, position: 2, state: .locked),
        PathNode(id: "c2-drill1", type: .drill(id: "endgame-pawns"), chapter: 2, position: 3, state: .locked),
        PathNode(id: "c2-tara", type: .bot(botId: "tara"), chapter: 2, position: 4, state: .locked),
        PathNode(id: "c2-trophy", type: .trophy(chapter: 2), chapter: 2, position: 5, state: .locked)
    ]
    
    static let chapter3: [PathNode] = [
        PathNode(id: "c3-sofia", type: .bot(botId: "sofia"), chapter: 3, position: 0, state: .locked),
        PathNode(id: "c3-drill1", type: .drill(id: "tactical-sequence"), chapter: 3, position: 1, state: .locked),
        PathNode(id: "c3-eli", type: .bot(botId: "eli"), chapter: 3, position: 2, state: .locked),
        PathNode(id: "c3-puzzle1", type: .puzzle(theme: "mate-in-2", count: 3), chapter: 3, position: 3, state: .locked),
        PathNode(id: "c3-grandmaster", type: .bot(botId: "grandmaster"), chapter: 3, position: 4, state: .locked),
        PathNode(id: "c3-trophy", type: .trophy(chapter: 3), chapter: 3, position: 5, state: .locked)
    ]
}
