import SwiftUI

struct PathMapView: View {
    @State private var nodes: [[PathNode]] = PathData.chapters
    @State private var selectedNode: PathNode?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KPSpacing.xxxl) {
                    ForEach(Array(nodes.enumerated()), id: \.offset) { chapterIndex, chapter in
                        VStack(spacing: KPSpacing.xl) {
                            chapterHeader(chapterIndex + 1)
                            
                            ForEach(chapter) { node in
                                nodeView(node)
                                    .onTapGesture {
                                        if case .available = node.state {
                                            selectedNode = node
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(KPColor.Background.soft)
            .navigationTitle("Your Path")
            .sheet(item: $selectedNode) { node in
                nodeDetailSheet(node)
            }
        }
    }
    
    private func chapterHeader(_ chapter: Int) -> some View {
        HStack {
            Text("Chapter \(chapter)")
                .font(KPFont.displayMedium())
                .foregroundColor(KPColor.Brand.primary)
            
            Spacer()
        }
    }
    
    private func nodeView(_ node: PathNode) -> some View {
        HStack(spacing: KPSpacing.md) {
            nodeIcon(node)
            
            VStack(alignment: .leading, spacing: KPSpacing.xxs) {
                Text(node.title)
                    .font(KPFont.bodyLarge())
                    .fontWeight(.semibold)
                    .foregroundColor(nodeTextColor(node.state))
                
                nodeStateLabel(node.state)
            }
            
            Spacer()
            
            if case .completed(let stars) = node.state {
                HStack(spacing: 2) {
                    ForEach(0..<stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(KPColor.Accent.gold)
                    }
                }
            }
        }
        .padding(KPSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: KPRadius.lg)
                .fill(nodeFillColor(node.state))
                .overlay(
                    RoundedRectangle(cornerRadius: KPRadius.lg)
                        .stroke(nodeBorderColor(node.state), lineWidth: 2)
                )
        )
        .opacity(nodeOpacity(node.state))
    }
    
    private func nodeIcon(_ node: PathNode) -> some View {
        ZStack {
            Circle()
                .fill(nodeIconBackground(node.state))
                .frame(width: 44, height: 44)
            
            Image(systemName: node.icon)
                .font(.system(size: 20))
                .foregroundColor(nodeIconColor(node.state))
        }
    }
    
    private func nodeStateLabel(_ state: NodeState) -> some View {
        let (text, color): (String, Color) = {
            switch state {
            case .locked:
                return ("Locked", KPColor.Text.secondary)
            case .available:
                return ("Available", KPColor.Brand.primary)
            case .inProgress:
                return ("In Progress", KPColor.Accent.gold)
            case .completed:
                return ("Completed", KPColor.success)
            }
        }()
        
        return Text(text)
            .font(KPFont.captionLarge())
            .foregroundColor(color)
    }
    
    private func nodeDetailSheet(_ node: PathNode) -> some View {
        VStack(spacing: KPSpacing.xl) {
            Text(node.title)
                .font(KPFont.displayLarge())
                .foregroundColor(KPColor.Text.primary)
            
            switch node.type {
            case .bot(let botId):
                if let bot = BotRoster.bot(withId: botId) {
                    botDetailView(bot)
                }
                
            case .puzzle(let theme, let count):
                Text("\(count) \(theme) puzzles")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.secondary)
                
            case .drill(let id):
                Text("Complete the \(id) drill")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.secondary)
                
            case .trophy:
                Text("Chapter trophy - complete all previous nodes")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.secondary)
            }
            
            KPButton("Challenge", style: .primary) {
                selectedNode = nil
            }
            
            KPButton("Back", style: .secondary) {
                selectedNode = nil
            }
        }
        .padding(KPSpacing.xl)
        .presentationDetents([.medium])
    }
    
    private func botDetailView(_ bot: BotDefinition) -> some View {
        VStack(spacing: KPSpacing.md) {
            AssetPlaceholder("bot-\(bot.id)-neutral", systemIcon: "person.circle", size: 100)
            
            Text(bot.persona)
                .font(KPFont.body())
                .foregroundColor(KPColor.Text.secondary)
                .multilineTextAlignment(.center)
            
            HStack {
                Text("Difficulty:")
                    .font(KPFont.bodySmall())
                    .foregroundColor(KPColor.Text.secondary)
                
                HStack(spacing: KPSpacing.xxs) {
                    ForEach(0..<bot.difficultyTier, id: \.self) { _ in
                        Circle()
                            .fill(KPColor.Brand.primary)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            Text("Weakness: \(bot.weaknessHint)")
                .font(KPFont.captionLarge())
                .foregroundColor(KPColor.Text.secondary)
                .padding(KPSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: KPRadius.sm)
                        .fill(KPColor.Background.soft)
                )
        }
    }
    
    private func nodeFillColor(_ state: NodeState) -> Color {
        switch state {
        case .locked:
            return KPColor.Card.border.opacity(0.2)
        case .available, .inProgress:
            return KPColor.Background.base
        case .completed:
            return KPColor.success.opacity(0.1)
        }
    }
    
    private func nodeBorderColor(_ state: NodeState) -> Color {
        switch state {
        case .locked:
            return KPColor.Card.border
        case .available:
            return KPColor.Brand.primary
        case .inProgress:
            return KPColor.Accent.gold
        case .completed:
            return KPColor.success
        }
    }
    
    private func nodeTextColor(_ state: NodeState) -> Color {
        case .locked: return KPColor.Text.secondary
        default: return KPColor.Text.primary
        }
    }
    
    private func nodeIconBackground(_ state: NodeState) -> Color {
        switch state {
        case .locked:
            return KPColor.Card.border.opacity(0.3)
        case .available:
            return KPColor.Brand.primary.opacity(0.2)
        case .inProgress:
            return KPColor.Accent.gold.opacity(0.2)
        case .completed:
            return KPColor.success.opacity(0.2)
        }
    }
    
    private func nodeIconColor(_ state: NodeState) -> Color {
        switch state {
        case .locked:
            return KPColor.Text.secondary
        case .available:
            return KPColor.Brand.primary
        case .inProgress:
            return KPColor.Accent.gold
        case .completed:
            return KPColor.success
        }
    }
    
    private func nodeOpacity(_ state: NodeState) -> Double {
        case .locked: return 0.6
        default: return 1.0
        }
    }
}

#Preview {
    PathMapView()
}
