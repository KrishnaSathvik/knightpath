import SwiftUI

struct KPButton: View {
    enum Style {
        case primary
        case secondary
    }
    
    let title: String
    let style: Style
    let action: () -> Void
    let isEnabled: Bool
    
    @State private var isPressed = false
    
    init(
        _ title: String,
        style: Style = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        Button {
            guard isEnabled else { return }
            performAction()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: KPRadius.lg)
                    .fill(bottomColor)
                    .frame(height: 56)
                
                RoundedRectangle(cornerRadius: KPRadius.lg)
                    .fill(topColor)
                    .frame(height: 56)
                    .offset(y: isPressed ? 0 : -4)
                
                Text(title)
                    .font(KPFont.displaySmall())
                    .foregroundColor(textColor)
                    .offset(y: isPressed ? 0 : -4)
            }
            .frame(height: 60)
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed && isEnabled {
                        isPressed = true
                        lightHaptic()
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
    
    private var topColor: Color {
        switch style {
        case .primary:
            return isEnabled ? KPColor.Brand.primary : KPColor.Brand.primary.opacity(0.5)
        case .secondary:
            return KPColor.Background.base
        }
    }
    
    private var bottomColor: Color {
        KPColor.Brand.dark
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return KPColor.Brand.primary
        }
    }
    
    private func performAction() {
        lightHaptic()
        action()
    }
    
    private func lightHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

#Preview("Button States") {
    VStack(spacing: KPSpacing.lg) {
        KPButton("Primary Button", style: .primary) {
            print("Primary tapped")
        }
        
        KPButton("Secondary Button", style: .secondary) {
            print("Secondary tapped")
        }
        
        KPButton("Disabled Button", isEnabled: false) {
            print("Should not print")
        }
    }
    .padding()
    .background(KPColor.Background.soft)
}
