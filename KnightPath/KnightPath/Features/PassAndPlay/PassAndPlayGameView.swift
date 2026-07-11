import SwiftUI

struct PassAndPlayGameView: View {
    let player1Name: String
    let player2Name: String
    let flipBoard: Bool
    
    @State private var viewModel = GameViewModel()
    @State private var showPassInterstitial = false
    @State private var rotationAngle: Double = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            KPColor.Background.base.ignoresSafeArea()
            
            VStack(spacing: KPSpacing.lg) {
                if !flipBoard {
                    playerHUD(name: player2Name, color: .black, isTop: true)
                }
                
                BoardView(viewModel: viewModel)
                    .padding(.horizontal, KPSpacing.md)
                    .rotation3DEffect(
                        .degrees(rotationAngle),
                        axis: (x: 1, y: 0, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.4), value: rotationAngle)
                
                if !flipBoard {
                    playerHUD(name: player1Name, color: .white, isTop: false)
                }
                
                actionButtons
            }
            .padding(.vertical, KPSpacing.lg)
            .opacity(showPassInterstitial ? 0 : 1)
            
            if showPassInterstitial {
                passInterstitial
            }
            
            if case .over(let result) = viewModel.phase {
                gameOverOverlay(result: result)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: KPSpacing.xs) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(KPColor.Brand.primary)
                }
            }
        }
        .onChange(of: viewModel.gameState.currentPlayer) { oldValue, newValue in
            if flipBoard && case .playing = viewModel.phase {
                showPassInterstitial = true
            }
        }
    }
    
    private func playerHUD(name: String, color: PieceColor, isTop: Bool) -> some View {
        let isCurrentPlayer = viewModel.gameState.currentPlayer == color
        
        return HStack {
            VStack(alignment: .leading, spacing: KPSpacing.xxs) {
                Text(name)
                    .font(KPFont.bodyLarge())
                    .fontWeight(isCurrentPlayer ? .bold : .regular)
                    .foregroundColor(KPColor.Text.primary)
                
                Text(color == .white ? "White" : "Black")
                    .font(KPFont.captionLarge())
                    .foregroundColor(isCurrentPlayer ? KPColor.Brand.primary : KPColor.Text.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, KPSpacing.lg)
        .opacity(isCurrentPlayer ? 1.0 : 0.6)
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
            
            Spacer()
        }
        .padding(.horizontal, KPSpacing.lg)
    }
    
    private var passInterstitial: some View {
        ZStack {
            KPColor.Brand.primary.opacity(0.95)
                .ignoresSafeArea()
            
            VStack(spacing: KPSpacing.xl) {
                Image(systemName: "arrow.turn.down.right")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("Pass to \(viewModel.gameState.currentPlayer == .white ? player1Name : player2Name)")
                    .font(KPFont.displayLarge())
                    .foregroundColor(.white)
                
                Text("Tap when ready")
                    .font(KPFont.body())
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .onTapGesture {
            withAnimation {
                rotationAngle += 180
                showPassInterstitial = false
            }
        }
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
                        rotationAngle = 0
                    }
                    
                    KPButton("Back to Menu", style: .secondary) {
                        dismiss()
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
            return "\(winner == .white ? player1Name : player2Name) Wins!"
        case .stalemate:
            return "Stalemate"
        case .draw:
            return "Draw"
        case .resignation(let winner):
            return "\(winner == .white ? player1Name : player2Name) Wins!"
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
}

#Preview {
    PassAndPlayGameView(player1Name: "Alice", player2Name: "Bob", flipBoard: true)
}
