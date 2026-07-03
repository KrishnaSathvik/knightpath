import SwiftUI
import ChessKit

struct BotGameView: View {
    @State private var viewModel: BotGameViewModel
    
    init(bot: BotDefinition, playerColor: PieceColor = .white) {
        self._viewModel = State(initialValue: BotGameViewModel(bot: bot, playerColor: playerColor))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                KPColor.Background.base.ignoresSafeArea()
                
                VStack(spacing: KPSpacing.lg) {
                    botHUD
                    
                    ZStack {
                        BoardView(viewModel: viewModel.gameViewModel)
                            .padding(.horizontal, KPSpacing.md)
                            .overlay(hintOverlay)
                        
                        if case .promotion(_, let pieces) = viewModel.gameViewModel.phase {
                            VStack {
                                Spacer()
                                PromotionPicker(availablePieces: pieces) { kind in
                                    viewModel.gameViewModel.promoteTopiece(kind)
                                }
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                    }
                    
                    playerHUD
                    
                    actionButtons
                }
                .padding(.vertical, KPSpacing.lg)
                
                if viewModel.isThinking {
                    thinkingOverlay
                }
                
                if case .over(let result) = viewModel.gameViewModel.phase {
                    gameOverOverlay(result: result)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.bot.name)
                        .font(KPFont.displaySmall())
                        .foregroundColor(KPColor.Text.primary)
                }
            }
        }
    }
    
    private var botHUD: some View {
        HStack {
            AssetPlaceholder("bot-\(viewModel.bot.id)-neutral", systemIcon: "person.circle", size: 50)
            
            VStack(alignment: .leading, spacing: KPSpacing.xxs) {
                Text(viewModel.bot.name)
                    .font(KPFont.bodyLarge())
                    .fontWeight(.bold)
                    .foregroundColor(KPColor.Text.primary)
                
                HStack(spacing: KPSpacing.xxs) {
                    ForEach(0..<viewModel.bot.difficultyTier, id: \.self) { _ in
                        Circle()
                            .fill(KPColor.Brand.primary)
                            .frame(width: 6, height: 6)
                    }
                }
            }
            
            Spacer()
            
            if let taunt = viewModel.currentTaunt {
                speechBubble(text: taunt)
            }
        }
        .padding(.horizontal, KPSpacing.lg)
    }
    
    private var playerHUD: some View {
        HStack {
            VStack(alignment: .leading, spacing: KPSpacing.xxs) {
                Text("You")
                    .font(KPFont.bodyLarge())
                    .fontWeight(.bold)
                    .foregroundColor(KPColor.Text.primary)
                
                Text(viewModel.playerColor == .white ? "White" : "Black")
                    .font(KPFont.captionLarge())
                    .foregroundColor(KPColor.Text.secondary)
            }
            
            Spacer()
            
            HStack(spacing: KPSpacing.sm) {
                KPPill(
                    icon: "lightbulb.fill",
                    text: "\(viewModel.hintSystem.hintsAvailable)",
                    color: viewModel.hintSystem.canUseHint() ? KPColor.Accent.gold : KPColor.Text.secondary
                )
            }
        }
        .padding(.horizontal, KPSpacing.lg)
    }
    
    private var actionButtons: some View {
        HStack(spacing: KPSpacing.md) {
            Button {
                viewModel.reset()
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 20))
                    .foregroundColor(KPColor.Text.primary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(KPColor.Background.base)
                            .shadow(color: KPColor.Card.border, radius: 2)
                    )
            }
            
            Button {
                Task {
                    await viewModel.requestHint()
                }
            } label: {
                HStack(spacing: KPSpacing.xs) {
                    Image(systemName: "lightbulb.fill")
                    Text("Hint")
                        .font(KPFont.bodySmall())
                }
                .foregroundColor(viewModel.hintSystem.canUseHint() ? KPColor.Accent.gold : KPColor.Text.secondary)
                .padding(.horizontal, KPSpacing.md)
                .padding(.vertical, KPSpacing.xs)
                .background(
                    Capsule()
                        .fill(KPColor.Background.base)
                        .shadow(color: KPColor.Card.border, radius: 2)
                )
            }
            .disabled(!viewModel.hintSystem.canUseHint())
            
            Spacer()
            
            Button {
                viewModel.resign()
            } label: {
                HStack(spacing: KPSpacing.xs) {
                    Image(systemName: "flag.fill")
                    Text("Resign")
                        .font(KPFont.bodySmall())
                }
                .foregroundColor(KPColor.danger)
                .padding(.horizontal, KPSpacing.md)
                .padding(.vertical, KPSpacing.xs)
                .background(
                    Capsule()
                        .fill(KPColor.Background.base)
                        .shadow(color: KPColor.Card.border, radius: 2)
                )
            }
        }
        .padding(.horizontal, KPSpacing.lg)
    }
    
    private var hintOverlay: some View {
        GeometryReader { geometry in
            if let hint = viewModel.hintSystem.currentHint {
                let squareSize = geometry.size.width / 8
                let fromX = CGFloat(fileIndex(hint.from)) * squareSize + squareSize / 2
                let fromY = CGFloat(7 - rankIndex(hint.from)) * squareSize + squareSize / 2
                let toX = CGFloat(fileIndex(hint.to)) * squareSize + squareSize / 2
                let toY = CGFloat(7 - rankIndex(hint.to)) * squareSize + squareSize / 2
                
                Path { path in
                    path.move(to: CGPoint(x: fromX, y: fromY))
                    path.addLine(to: CGPoint(x: toX, y: toY))
                }
                .stroke(KPColor.Accent.gold, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .shadow(color: .black.opacity(0.3), radius: 4)
                
                Circle()
                    .fill(KPColor.Accent.gold)
                    .frame(width: 16, height: 16)
                    .position(x: toX, y: toY)
                    .shadow(color: .black.opacity(0.3), radius: 4)
            }
        }
    }
    
    private var thinkingOverlay: some View {
        VStack {
            HStack {
                Spacer()
                
                HStack(spacing: KPSpacing.xs) {
                    ProgressView()
                        .tint(KPColor.Brand.primary)
                    Text("Thinking...")
                        .font(KPFont.bodySmall())
                        .foregroundColor(KPColor.Text.primary)
                }
                .padding(KPSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: KPRadius.md)
                        .fill(KPColor.Background.base)
                        .shadow(color: .black.opacity(0.2), radius: 8)
                )
                .padding(.trailing, KPSpacing.lg)
                
                Spacer()
            }
            Spacer()
        }
    }
    
    private func speechBubble(text: String) -> some View {
        Text(text)
            .font(KPFont.captionLarge())
            .foregroundColor(KPColor.Text.primary)
            .padding(.horizontal, KPSpacing.sm)
            .padding(.vertical, KPSpacing.xs)
            .background(
                Capsule()
                    .fill(KPColor.Background.base)
                    .shadow(color: KPColor.Card.border, radius: 2)
            )
            .transition(.scale.combined(with: .opacity))
    }
    
    private func gameOverOverlay(result: GameResult) -> some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            KPCard(background: .white) {
                VStack(spacing: KPSpacing.lg) {
                    Text(resultTitle(result))
                        .font(KPFont.displayLarge())
                        .foregroundColor(KPColor.Text.primary)
                    
                    Text(resultMessage(result))
                        .font(KPFont.body())
                        .foregroundColor(KPColor.Text.secondary)
                        .multilineTextAlignment(.center)
                    
                    KPButton("New Game", style: .primary) {
                        viewModel.reset()
                    }
                }
                .padding(KPSpacing.xl)
            }
            .padding(KPSpacing.xl)
        }
    }
    
    private func resultTitle(_ result: GameResult) -> String {
        switch result {
        case .checkmate(let winner):
            return winner == viewModel.playerColor ? "Victory!" : "Defeat"
        case .stalemate:
            return "Stalemate"
        case .draw:
            return "Draw"
        case .resignation(let winner):
            return winner == viewModel.playerColor ? "Victory!" : "Defeat"
        }
    }
    
    private func resultMessage(_ result: GameResult) -> String {
        switch result {
        case .checkmate:
            return "Checkmate"
        case .stalemate:
            return "The game is a draw by stalemate"
        case .draw:
            return "The game ended in a draw"
        case .resignation:
            return "By resignation"
        }
    }
    
    private func fileIndex(_ square: Square) -> Int {
        square.file.rawValue
    }
    
    private func rankIndex(_ square: Square) -> Int {
        square.rank.rawValue - 1
    }
}

#Preview {
    BotGameView(bot: BotRoster.rookieRyan)
}
