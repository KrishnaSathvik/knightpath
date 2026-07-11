import SwiftUI

struct PostGameView: View {
    let result: GameResult
    let playerColor: PieceColor
    let botName: String?
    let accuracy: Double
    let stars: Int
    let xpEarned: Int
    let coinsEarned: Int
    let hintsUsed: Int
    
    let onDismiss: () -> Void
    let onRematch: () -> Void
    
    @State private var showStars = false
    @State private var showXP = false
    @State private var showCoins = false
    @State private var currentXP = 0
    @State private var currentCoins = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            KPCard(background: .white) {
                VStack(spacing: KPSpacing.xl) {
                    resultBanner
                    
                    if showStars && stars > 0 {
                        starsView
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    if showXP {
                        rewardRow(
                            icon: "star.circle.fill",
                            color: KPColor.Brand.primary,
                            label: "XP",
                            value: currentXP
                        )
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    if showCoins {
                        rewardRow(
                            icon: "bitcoinsign.circle.fill",
                            color: KPColor.Accent.gold,
                            label: "Coins",
                            value: currentCoins
                        )
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    accuracySection
                    
                    actionButtons
                }
                .padding(KPSpacing.xl)
            }
            .padding(KPSpacing.xl)
        }
        .onAppear {
            animateRewards()
        }
    }
    
    private var resultBanner: some View {
        VStack(spacing: KPSpacing.sm) {
            Text(resultTitle)
                .font(KPFont.displayLarge())
                .foregroundColor(resultColor)
            
            if let botName = botName {
                Text("vs \(botName)")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.secondary)
            }
        }
    }
    
    private var starsView: some View {
        HStack(spacing: KPSpacing.sm) {
            ForEach(0..<3, id: \.self) { index in
                Image(systemName: index < stars ? "star.fill" : "star")
                    .font(.system(size: 32))
                    .foregroundColor(index < stars ? KPColor.Accent.gold : KPColor.Card.border)
            }
        }
    }
    
    private func rewardRow(icon: String, color: Color, label: String, value: Int) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(label)
                .font(KPFont.bodyLarge())
                .foregroundColor(KPColor.Text.primary)
            
            Spacer()
            
            Text("+\(value)")
                .font(KPFont.displayMedium())
                .fontWeight(.bold)
                .foregroundColor(color)
                .contentTransition(.numericText())
        }
    }
    
    private var accuracySection: some View {
        VStack(spacing: KPSpacing.sm) {
            Text("Accuracy")
                .font(KPFont.bodyLarge())
                .foregroundColor(KPColor.Text.secondary)
            
            ZStack {
                Circle()
                    .stroke(KPColor.Card.border, lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: accuracy)
                    .stroke(accuracyColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(accuracy * 100))%")
                    .font(KPFont.displayMedium())
                    .fontWeight(.bold)
                    .foregroundColor(KPColor.Text.primary)
            }
            
            if hintsUsed > 0 {
                Text("Hints used: \(hintsUsed)")
                    .font(KPFont.caption())
                    .foregroundColor(KPColor.Text.secondary)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: KPSpacing.md) {
            if botName != nil {
                KPButton("Rematch", style: .primary) {
                    onRematch()
                }
            }
            
            KPButton(botName != nil ? "Continue" : "Close", style: .secondary) {
                onDismiss()
            }
        }
    }
    
    private var resultTitle: String {
        switch result {
        case .checkmate(let winner):
            return winner == playerColor ? "Victory!" : "Defeat"
        case .stalemate:
            return "Stalemate"
        case .draw:
            return "Draw"
        case .resignation(let winner):
            return winner == playerColor ? "Victory!" : "Defeat"
        }
    }
    
    private var resultColor: Color {
        switch result {
        case .checkmate(let winner), .resignation(let winner):
            return winner == playerColor ? KPColor.success : KPColor.danger
        default:
            return KPColor.Text.primary
        }
    }
    
    private var accuracyColor: Color {
        if accuracy >= 0.85 {
            return KPColor.success
        } else if accuracy >= 0.70 {
            return KPColor.Accent.gold
        } else {
            return KPColor.danger
        }
    }
    
    private func animateRewards() {
        Task {
            HapticsService.shared.checkmate()
            
            try? await Task.sleep(for: .seconds(0.5))
            
            if stars > 0 {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showStars = true
                }
                
                for i in 0..<stars {
                    try? await Task.sleep(for: .seconds(0.3))
                    HapticsService.shared.rigid()
                }
            }
            
            try? await Task.sleep(for: .seconds(0.3))
            
            withAnimation {
                showXP = true
            }
            
            if xpEarned > 0 {
                let steps = 20
                let increment = xpEarned / steps
                for _ in 0..<steps {
                    try? await Task.sleep(for: .seconds(0.02))
                    currentXP = min(currentXP + increment, xpEarned)
                    HapticsService.shared.tick()
                }
                currentXP = xpEarned
            }
            
            try? await Task.sleep(for: .seconds(0.2))
            
            withAnimation {
                showCoins = true
            }
            
            if coinsEarned > 0 {
                let steps = 20
                let increment = coinsEarned / steps
                for _ in 0..<steps {
                    try? await Task.sleep(for: .seconds(0.02))
                    currentCoins = min(currentCoins + increment, coinsEarned)
                    HapticsService.shared.tick()
                }
                currentCoins = coinsEarned
            }
        }
    }
}

#Preview {
    PostGameView(
        result: .checkmate(winner: .white),
        playerColor: .white,
        botName: "Rookie Ryan",
        accuracy: 0.87,
        stars: 3,
        xpEarned: 175,
        coinsEarned: 85,
        hintsUsed: 0,
        onDismiss: {},
        onRematch: {}
    )
}
