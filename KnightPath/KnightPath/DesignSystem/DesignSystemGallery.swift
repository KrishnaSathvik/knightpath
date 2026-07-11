import SwiftUI

struct DesignSystemGallery: View {
    @State private var selectedChip = 0
    @State private var ringProgress = 0.65
    @State private var barProgress = 0.45
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: KPSpacing.xl) {
                    colorsSection
                    typographySection
                    buttonsSection
                    cardsSection
                    pillsSection
                    progressSection
                    chipsSection
                    placeholdersSection
                }
                .padding()
            }
            .background(KPColor.Background.base)
            .navigationTitle("Design System")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            sectionTitle("Colors")
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: KPSpacing.sm) {
                colorSwatch("Primary", KPColor.Brand.primary)
                colorSwatch("Dark", KPColor.Brand.dark)
                colorSwatch("Gold", KPColor.Accent.gold)
                colorSwatch("Success", KPColor.success)
                colorSwatch("Danger", KPColor.danger)
                colorSwatch("Streak", KPColor.streak)
                colorSwatch("Board Dark", KPColor.Board.dark)
                colorSwatch("Board Light", KPColor.Board.light)
            }
        }
    }
    
    private var typographySection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            sectionTitle("Typography")
            
            VStack(alignment: .leading, spacing: KPSpacing.xs) {
                Text("Display Large")
                    .font(KPFont.displayLarge())
                    .foregroundColor(KPColor.Text.primary)
                
                Text("Display Medium")
                    .font(KPFont.displayMedium())
                    .foregroundColor(KPColor.Text.primary)
                
                Text("Display Small")
                    .font(KPFont.displaySmall())
                    .foregroundColor(KPColor.Text.primary)
                
                Text("Body Large - The quick brown fox")
                    .font(KPFont.bodyLarge())
                    .foregroundColor(KPColor.Text.primary)
                
                Text("Body Medium - The quick brown fox")
                    .font(KPFont.bodyMedium())
                    .foregroundColor(KPColor.Text.secondary)
                
                Text("Caption - Small descriptive text")
                    .font(KPFont.captionLarge())
                    .foregroundColor(KPColor.Text.secondary)
            }
        }
    }
    
    private var buttonsSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            sectionTitle("Buttons")
            
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
    }
    
    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            sectionTitle("Cards")
            
            KPCard(background: .white) {
                Text("White card with border")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.primary)
            }
            
            KPCard(background: .soft) {
                Text("Soft lavender card")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.primary)
            }
        }
    }
    
    private var pillsSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            sectionTitle("Pills")
            
            HStack(spacing: KPSpacing.sm) {
                KPPill(icon: "bitcoinsign.circle.fill", text: "1,250", color: KPColor.Accent.gold)
                KPPill(icon: "flame.fill", text: "7", color: KPColor.streak)
                KPPill(icon: "star.fill", text: "125", color: KPColor.Brand.primary)
            }
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            sectionTitle("Progress")
            
            HStack(spacing: KPSpacing.lg) {
                ZStack {
                    KPLevelRing(progress: ringProgress, lineWidth: 6)
                    VStack(spacing: 2) {
                        Text("\(Int(ringProgress * 100))%")
                            .font(KPFont.bodySmall())
                            .fontWeight(.bold)
                            .foregroundColor(KPColor.Text.primary)
                        Text("Level 5")
                            .font(KPFont.captionSmall())
                            .foregroundColor(KPColor.Text.secondary)
                    }
                }
                .frame(width: 80, height: 80)
                
                Spacer()
            }
            
            VStack(spacing: KPSpacing.xs) {
                HStack {
                    Text("XP Progress")
                        .font(KPFont.bodySmall())
                        .foregroundColor(KPColor.Text.secondary)
                    Spacer()
                    Text("\(Int(barProgress * 100))%")
                        .font(KPFont.bodySmall())
                        .fontWeight(.semibold)
                        .foregroundColor(KPColor.Text.primary)
                        .monospacedDigit()
                }
                KPProgressBar(progress: barProgress, height: 10, color: KPColor.Brand.primary)
            }
        }
    }
    
    private var chipsSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            sectionTitle("Chips")
            
            KPChip(options: ["None", "5 min", "10 min"], selectedIndex: $selectedChip)
        }
    }
    
    private var placeholdersSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            sectionTitle("Asset Placeholders")
            
            HStack(spacing: KPSpacing.md) {
                AssetPlaceholder("piece-w-knight", systemIcon: "crown.fill", size: 60)
                AssetPlaceholder("bot-greg-neutral", systemIcon: "person.circle", size: 60)
                AssetPlaceholder("pathy-idle", systemIcon: "figure.wave", size: 60)
            }
        }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(KPFont.displayMedium())
            .foregroundColor(KPColor.Text.primary)
            .padding(.top, KPSpacing.sm)
    }
    
    private func colorSwatch(_ name: String, _ color: Color) -> some View {
        VStack(spacing: KPSpacing.xxs) {
            RoundedRectangle(cornerRadius: KPRadius.sm)
                .fill(color)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: KPRadius.sm)
                        .stroke(KPColor.Card.border, lineWidth: 1)
                )
            
            Text(name)
                .font(KPFont.captionSmall())
                .foregroundColor(KPColor.Text.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    DesignSystemGallery()
}
