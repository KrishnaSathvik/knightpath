import SwiftUI

struct AssetPlaceholder: View {
    let assetName: String
    let systemIcon: String
    let size: CGFloat
    
    init(_ assetName: String, systemIcon: String = "photo", size: CGFloat = 100) {
        self.assetName = assetName
        self.systemIcon = systemIcon
        self.size = size
    }
    
    var body: some View {
        VStack(spacing: KPSpacing.xs) {
            RoundedRectangle(cornerRadius: KPRadius.md)
                .fill(KPColor.Card.border.opacity(0.3))
                .frame(width: size, height: size)
                .overlay(
                    Image(systemName: systemIcon)
                        .font(.system(size: size * 0.4))
                        .foregroundColor(KPColor.Text.secondary.opacity(0.5))
                )
            
            Text(assetName)
                .font(KPFont.captionSmall())
                .foregroundColor(KPColor.Text.secondary)
                .multilineTextAlignment(.center)
                .frame(width: size)
        }
    }
}

#Preview("Asset Placeholders") {
    VStack(spacing: KPSpacing.lg) {
        HStack(spacing: KPSpacing.md) {
            AssetPlaceholder("piece-w-knight", systemIcon: "crown.fill", size: 80)
            AssetPlaceholder("bot-greg-neutral", systemIcon: "person.circle", size: 80)
            AssetPlaceholder("icon-coin", systemIcon: "bitcoinsign.circle", size: 60)
        }
        
        AssetPlaceholder("pathy-idle", systemIcon: "figure.wave", size: 120)
    }
    .padding()
    .background(KPColor.Background.soft)
}
