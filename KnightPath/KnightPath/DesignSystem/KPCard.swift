import SwiftUI

struct KPCard<Content: View>: View {
    enum Background {
        case white
        case soft
    }
    
    let background: Background
    let content: Content
    
    init(background: Background = .white, @ViewBuilder content: () -> Content) {
        self.background = background
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(KPSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: KPRadius.xl)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: KPRadius.xl)
                            .stroke(KPColor.Card.border, lineWidth: 2)
                    )
            )
    }
    
    private var backgroundColor: Color {
        switch background {
        case .white:
            return KPColor.Background.base
        case .soft:
            return KPColor.Background.soft
        }
    }
}

#Preview("Card Variants") {
    VStack(spacing: KPSpacing.lg) {
        KPCard(background: .white) {
            VStack(alignment: .leading, spacing: KPSpacing.xs) {
                Text("White Card")
                    .font(KPFont.displaySmall())
                    .foregroundColor(KPColor.Text.primary)
                Text("Default white background with border")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.secondary)
            }
        }
        
        KPCard(background: .soft) {
            VStack(alignment: .leading, spacing: KPSpacing.xs) {
                Text("Soft Card")
                    .font(KPFont.displaySmall())
                    .foregroundColor(KPColor.Text.primary)
                Text("Lavender-tinted background")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.secondary)
            }
        }
    }
    .padding()
    .background(KPColor.Background.base)
}
