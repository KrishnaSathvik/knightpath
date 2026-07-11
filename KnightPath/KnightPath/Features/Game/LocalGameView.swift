import SwiftUI
import ChessKit

struct LocalGameView: View {
    @State private var viewModel = GameViewModel()
    @State private var showingPromotionPicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                KPColor.Background.base.ignoresSafeArea()
                
                VStack(spacing: KPSpacing.lg) {
                    playerHUD(isTop: true)
                    
                    ZStack {
                        BoardView(viewModel: viewModel)
                            .padding(.horizontal, KPSpacing.md)
                        
                        if case .promotion(_, let pieces) = viewModel.phase {
                            VStack {
                                Spacer()
                                PromotionPicker(availablePieces: pieces) { kind in
                                    viewModel.promoteTopiece(kind)
                                }
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                    }
                    
                    playerHUD(isTop: false)
                    
                    actionButtons
                }
                .padding(.vertical, KPSpacing.lg)
                
                if case .over(let result) = viewModel.phase {
                    gameOverOverlay(result: result)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Two Player Game")
                        .font(KPFont.displaySmall())
                        .foregroundColor(KPColor.Text.primary)
                }
            }
        }
    }
    
    private func playerHUD(isTop: Bool) -> some View {
        let isCurrentPlayer = isTop ? (viewModel.gameState.currentPlayer == .black) : (viewModel.gameState.currentPlayer == .white)
        let playerColor: PieceColor = isTop ? .black : .white
        
        return HStack {
            VStack(alignment: .leading, spacing: KPSpacing.xxs) {
                Text(playerColor == .white ? "White" : "Black")
                    .font(KPFont.bodyLarge())
                    .fontWeight(isCurrentPlayer ? .bold : .regular)
                    .foregroundColor(KPColor.Text.primary)
                
                Text(isCurrentPlayer ? "Your turn" : "Waiting...")
                    .font(KPFont.captionLarge())
                    .foregroundColor(isCurrentPlayer ? KPColor.Brand.primary : KPColor.Text.secondary)
            }
            
            Spacer()
            
            capturedPiecesView(for: playerColor.opposite)
        }
        .padding(.horizontal, KPSpacing.lg)
        .opacity(isCurrentPlayer ? 1.0 : 0.6)
    }
    
    private func capturedPiecesView(for color: PieceColor) -> some View {
        let captured = color == .white ? viewModel.capturedPieces.white : viewModel.capturedPieces.black
        
        return HStack(spacing: 2) {
            ForEach(Array(captured.enumerated()), id: \.offset) { _, piece in
                Image(systemName: systemIcon(for: piece.kind))
                    .font(.system(size: 12))
                    .foregroundColor(KPColor.Text.secondary.opacity(0.6))
            }
        }
        .frame(height: 20)
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
            return winner == .white ? "White Wins!" : "Black Wins!"
        case .stalemate:
            return "Stalemate"
        case .draw:
            return "Draw"
        case .resignation(let winner):
            return winner == .white ? "White Wins!" : "Black Wins!"
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
    
    private func systemIcon(for kind: Piece.Kind) -> String {
        switch kind {
        case .king: return "crown.fill"
        case .queen: return "crown"
        case .rook: return "building.columns.fill"
        case .bishop: return "triangle.fill"
        case .knight: return "star.fill"
        case .pawn: return "circle.fill"
        }
    }
}

#Preview {
    LocalGameView()
}
