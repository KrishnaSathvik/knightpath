import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [PlayerProfile]
    
    private var profile: PlayerProfile {
        profiles.first ?? PlayerProfile()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KPSpacing.xl) {
                    heroCard
                    
                    modeGrid
                }
                .padding()
            }
            .background(KPColor.Background.soft)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: KPSpacing.sm) {
                        AssetPlaceholder("logo-knight-mark", systemIcon: "crown.fill", size: 32)
                        Text("KnightPath")
                            .font(KPFont.displaySmall())
                            .foregroundColor(KPColor.Text.primary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: KPSpacing.sm) {
                        KPPill(icon: "bitcoinsign.circle.fill", text: "\(profile.coins)", color: KPColor.Accent.gold)
                        
                        if profile.currentStreak > 0 {
                            KPPill(icon: "flame.fill", text: "\(profile.currentStreak)", color: KPColor.streak)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    ZStack {
                        KPLevelRing(progress: profile.xpProgress, lineWidth: 4)
                            .frame(width: 44, height: 44)
                        
                        Text("\(profile.level)")
                            .font(KPFont.captionSmall())
                            .fontWeight(.bold)
                            .foregroundColor(KPColor.Text.primary)
                    }
                }
            }
        }
    }
    
    private var heroCard: some View {
        KPCard(background: .soft) {
            VStack(spacing: KPSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: KPSpacing.xs) {
                        Text("Continue Your Path")
                            .font(KPFont.displayMedium())
                            .foregroundColor(KPColor.Text.primary)
                        
                        Text("Next: Rookie Ryan")
                            .font(KPFont.body())
                            .foregroundColor(KPColor.Text.secondary)
                    }
                    
                    Spacer()
                    
                    AssetPlaceholder("bot-ryan-neutral", systemIcon: "person.circle", size: 60)
                }
                
                KPButton("Challenge", style: .primary) {
                    // TODO: Navigate to bot game
                }
            }
        }
    }
    
    private var modeGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: KPSpacing.md) {
            modeCard(
                title: "Pass & Play",
                icon: "person.2.fill",
                color: KPColor.Brand.primary,
                isLocked: false
            ) {
                // TODO: Navigate to Pass & Play
            }
            
            modeCard(
                title: "Daily Puzzles",
                icon: "puzzlepiece.fill",
                color: KPColor.Accent.gold,
                isLocked: false
            ) {
                // TODO: Navigate to Puzzles
            }
            
            modeCard(
                title: "Practice",
                icon: "target",
                color: KPColor.success,
                isLocked: false
            ) {
                // TODO: Navigate to Practice
            }
            
            modeCard(
                title: "Boss Battles",
                icon: "crown.fill",
                color: KPColor.danger,
                isLocked: true
            ) {
                // Coming soon
            }
        }
    }
    
    private func modeCard(title: String, icon: String, color: Color, isLocked: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            KPCard(background: .white) {
                VStack(spacing: KPSpacing.sm) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: icon)
                            .font(.system(size: 28))
                            .foregroundColor(color)
                    }
                    
                    Text(title)
                        .font(KPFont.bodyLarge())
                        .fontWeight(.semibold)
                        .foregroundColor(KPColor.Text.primary)
                        .multilineTextAlignment(.center)
                    
                    if isLocked {
                        Text("Coming Soon")
                            .font(KPFont.captionSmall())
                            .foregroundColor(KPColor.Text.secondary)
                    }
                }
                .frame(height: 140)
                .opacity(isLocked ? 0.6 : 1.0)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isLocked)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: PlayerProfile.self, inMemory: true)
}
