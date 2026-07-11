import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            KPColor.Background.soft
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                page1.tag(0)
                page2.tag(1)
                page3.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
    
    private var page1: some View {
        VStack(spacing: KPSpacing.xxxl) {
            Spacer()
            
            Image(systemName: "person.3.fill")
                .font(.system(size: 100))
                .foregroundColor(KPColor.Brand.primary)
            
            VStack(spacing: KPSpacing.md) {
                Text("Battle Characters, Not Levels")
                    .font(KPFont.displayLarge())
                    .fontWeight(.bold)
                    .foregroundColor(KPColor.Text.primary)
                    .multilineTextAlignment(.center)
                
                Text("Face 9 unique bot personalities, each with distinct playing styles and weaknesses")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, KPSpacing.xl)
    }
    
    private var page2: some View {
        VStack(spacing: KPSpacing.xxxl) {
            Spacer()
            
            HStack(spacing: KPSpacing.lg) {
                Image(systemName: "star.fill")
                    .font(.system(size: 50))
                    .foregroundColor(KPColor.Accent.gold)
                
                Image(systemName: "bitcoinsign.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(KPColor.Accent.gold)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 50))
                    .foregroundColor(KPColor.streak)
            }
            
            VStack(spacing: KPSpacing.md) {
                Text("Earn XP & Coins Every Game")
                    .font(KPFont.displayLarge())
                    .fontWeight(.bold)
                    .foregroundColor(KPColor.Text.primary)
                    .multilineTextAlignment(.center)
                
                Text("Even losses reward you. No energy system—play as much as you want")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, KPSpacing.xl)
    }
    
    private var page3: some View {
        VStack(spacing: KPSpacing.xxxl) {
            Spacer()
            
            Text("Make Your First Move")
                .font(KPFont.displayLarge())
                .fontWeight(.bold)
                .foregroundColor(KPColor.Text.primary)
                .multilineTextAlignment(.center)
            
            MiniChessBoard()
            
            Text("Move the knight to the highlighted square")
                .font(KPFont.body())
                .foregroundColor(KPColor.Text.secondary)
                .multilineTextAlignment(.center)
            
            KPButton("Begin Your Path", style: .primary) {
                withAnimation {
                    isPresented = false
                }
            }
            .padding(.horizontal, KPSpacing.xl)
            
            Spacer()
        }
        .padding(.horizontal, KPSpacing.xl)
    }
}

struct MiniChessBoard: View {
    @State private var knightPosition = 0
    private let targetPosition = 5
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<4, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { col in
                        let index = row * 4 + col
                        let isDark = (row + col) % 2 == 0
                        
                        square(index: index, isDark: isDark)
                    }
                }
            }
        }
        .frame(width: 200, height: 200)
        .cornerRadius(KPRadius.md)
    }
    
    private func square(index: Int, isDark: Bool) -> some View {
        ZStack {
            Rectangle()
                .fill(isDark ? KPColor.Board.dark : KPColor.Board.light)
            
            if index == targetPosition && knightPosition != targetPosition {
                Circle()
                    .fill(KPColor.Brand.primary.opacity(0.5))
                    .frame(width: 15, height: 15)
            }
            
            if index == knightPosition {
                Image(systemName: "star.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 50, height: 50)
        .onTapGesture {
            if index == targetPosition && knightPosition != targetPosition {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    knightPosition = targetPosition
                }
                HapticsService.shared.checkmate()
            }
        }
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
