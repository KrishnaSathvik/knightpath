import SwiftUI

struct KPPill: View {
    let icon: String
    let text: String
    let color: Color
    
    init(icon: String, text: String, color: Color = KPColor.Accent.gold) {
        self.icon = icon
        self.text = text
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: KPSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
            
            Text(text)
                .font(KPFont.bodySmall())
                .fontWeight(.semibold)
                .monospacedDigit()
        }
        .foregroundColor(.white)
        .padding(.horizontal, KPSpacing.sm)
        .padding(.vertical, KPSpacing.xs)
        .background(
            Capsule()
                .fill(color)
        )
    }
}

#Preview("Pill Variants") {
    VStack(spacing: KPSpacing.md) {
        KPPill(icon: "bitcoinsign.circle.fill", text: "1,250", color: KPColor.Accent.gold)
        KPPill(icon: "flame.fill", text: "7", color: KPColor.streak)
        KPPill(icon: "star.fill", text: "125", color: KPColor.Brand.primary)
    }
    .padding()
    .background(KPColor.Background.soft)
}
