import SwiftUI

struct KPProgressBar: View {
    let progress: Double
    let height: CGFloat
    let color: Color
    
    init(progress: Double, height: CGFloat = 8, color: Color = KPColor.Brand.primary) {
        self.progress = min(max(progress, 0), 1)
        self.height = height
        self.color = color
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(KPColor.Card.border)
                    .frame(height: height)
                
                Capsule()
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: height)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: height)
    }
}

#Preview("Progress Bar") {
    VStack(spacing: KPSpacing.lg) {
        VStack(alignment: .leading, spacing: KPSpacing.xs) {
            Text("XP Progress")
                .font(KPFont.bodySmall())
                .foregroundColor(KPColor.Text.secondary)
            KPProgressBar(progress: 0.35, height: 8, color: KPColor.Brand.primary)
        }
        
        VStack(alignment: .leading, spacing: KPSpacing.xs) {
            Text("Accuracy")
                .font(KPFont.bodySmall())
                .foregroundColor(KPColor.Text.secondary)
            KPProgressBar(progress: 0.72, height: 10, color: KPColor.success)
        }
        
        VStack(alignment: .leading, spacing: KPSpacing.xs) {
            Text("Streak Progress")
                .font(KPFont.bodySmall())
                .foregroundColor(KPColor.Text.secondary)
            KPProgressBar(progress: 0.9, height: 12, color: KPColor.streak)
        }
    }
    .padding()
    .background(KPColor.Background.soft)
}
