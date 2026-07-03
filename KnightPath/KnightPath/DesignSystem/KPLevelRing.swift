import SwiftUI

struct KPLevelRing: View {
    let progress: Double
    let lineWidth: CGFloat
    
    init(progress: Double, lineWidth: CGFloat = 6) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    KPColor.Card.border,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    KPColor.Brand.primary,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)
        }
    }
}

#Preview("Level Ring Progress") {
    HStack(spacing: KPSpacing.xl) {
        ZStack {
            KPLevelRing(progress: 0.25, lineWidth: 6)
            Text("25%")
                .font(KPFont.caption())
                .foregroundColor(KPColor.Text.primary)
        }
        .frame(width: 80, height: 80)
        
        ZStack {
            KPLevelRing(progress: 0.5, lineWidth: 6)
            Text("50%")
                .font(KPFont.caption())
                .foregroundColor(KPColor.Text.primary)
        }
        .frame(width: 80, height: 80)
        
        ZStack {
            KPLevelRing(progress: 0.75, lineWidth: 6)
            Text("75%")
                .font(KPFont.caption())
                .foregroundColor(KPColor.Text.primary)
        }
        .frame(width: 80, height: 80)
    }
    .padding()
    .background(KPColor.Background.soft)
}
