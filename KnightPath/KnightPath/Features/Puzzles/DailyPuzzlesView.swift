import SwiftUI

struct DailyPuzzlesView: View {
    @State private var completedToday = 0
    @State private var currentStreak = 5
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KPSpacing.xl) {
                    streakHeader
                    
                    puzzlesList
                }
                .padding()
            }
            .background(KPColor.Background.soft)
            .navigationTitle("Daily Puzzles")
        }
    }
    
    private var streakHeader: some View {
        KPCard(background: .white) {
            HStack(spacing: KPSpacing.lg) {
                VStack(alignment: .leading, spacing: KPSpacing.xs) {
                    HStack(spacing: KPSpacing.xs) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(KPColor.streak)
                        Text("\(currentStreak) Day Streak")
                            .font(KPFont.displaySmall())
                            .fontWeight(.bold)
                            .foregroundColor(KPColor.Text.primary)
                    }
                    
                    Text("\(completedToday)/5 completed today")
                        .font(KPFont.body())
                        .foregroundColor(KPColor.Text.secondary)
                }
                
                Spacer()
                
                CircularProgressView(progress: Double(completedToday) / 5.0)
            }
        }
    }
    
    private var puzzlesList: some View {
        VStack(spacing: KPSpacing.md) {
            ForEach(0..<5, id: \.self) { index in
                puzzleCard(index: index + 1, isCompleted: index < completedToday)
            }
        }
    }
    
    private func puzzleCard(index: Int, isCompleted: Bool) -> some View {
        Button {
            // TODO: Start puzzle
        } label: {
            KPCard(background: .white) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(isCompleted ? KPColor.success.opacity(0.2) : KPColor.Brand.primary.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(KPColor.success)
                        } else {
                            Text("\(index)")
                                .font(KPFont.displaySmall())
                                .fontWeight(.bold)
                                .foregroundColor(KPColor.Brand.primary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: KPSpacing.xxs) {
                        Text("Puzzle \(index)")
                            .font(KPFont.bodyLarge())
                            .fontWeight(.semibold)
                            .foregroundColor(KPColor.Text.primary)
                        
                        Text(isCompleted ? "Completed" : "Tactical puzzle")
                            .font(KPFont.body())
                            .foregroundColor(KPColor.Text.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(KPColor.Text.secondary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isCompleted)
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(KPColor.Card.border, lineWidth: 6)
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(KPColor.success, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 5))/5")
                .font(KPFont.bodySmall())
                .fontWeight(.bold)
                .foregroundColor(KPColor.Text.primary)
        }
    }
}

#Preview {
    DailyPuzzlesView()
}
