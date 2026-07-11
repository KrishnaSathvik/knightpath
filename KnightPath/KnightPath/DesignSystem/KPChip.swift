import SwiftUI

struct KPChip: View {
    let options: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(spacing: KPSpacing.xxs) {
            ForEach(options.indices, id: \.self) { index in
                chipButton(for: index)
            }
        }
        .padding(KPSpacing.xxs)
        .background(
            Capsule()
                .fill(KPColor.Card.border.opacity(0.3))
        )
    }
    
    private func chipButton(for index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedIndex = index
                lightHaptic()
            }
        } label: {
            Text(options[index])
                .font(KPFont.bodySmall())
                .fontWeight(.medium)
                .foregroundColor(selectedIndex == index ? .white : KPColor.Text.primary)
                .padding(.horizontal, KPSpacing.md)
                .padding(.vertical, KPSpacing.xs)
                .background(
                    Capsule()
                        .fill(selectedIndex == index ? KPColor.Brand.primary : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func lightHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

#Preview("Chip Selector") {
    struct ChipPreview: View {
        @State private var selected = 0
        
        var body: some View {
            VStack(spacing: KPSpacing.xl) {
                KPChip(options: ["None", "5 min", "10 min"], selectedIndex: $selected)
                
                KPChip(options: ["Easy", "Medium", "Hard"], selectedIndex: .constant(1))
                
                KPChip(options: ["White", "Black"], selectedIndex: .constant(0))
            }
            .padding()
            .background(KPColor.Background.soft)
        }
    }
    
    return ChipPreview()
}
