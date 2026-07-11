import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [PlayerProfile]
    
    private var profile: PlayerProfile {
        profiles.first ?? PlayerProfile()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KPSpacing.xl) {
                    profileHeader
                    
                    statsSection
                    
                    badgesSection
                    
                    settingsSection
                }
                .padding()
            }
            .background(KPColor.Background.soft)
            .navigationTitle("Profile")
        }
    }
    
    private var profileHeader: some View {
        KPCard(background: .white) {
            VStack(spacing: KPSpacing.md) {
                ZStack {
                    KPLevelRing(progress: profile.xpProgress, lineWidth: 8)
                        .frame(width: 100, height: 100)
                    
                    AssetPlaceholder("pathy-idle", systemIcon: "person.circle.fill", size: 80)
                }
                
                VStack(spacing: KPSpacing.xs) {
                    Text("Level \(profile.level)")
                        .font(KPFont.displayLarge())
                        .fontWeight(.bold)
                        .foregroundColor(KPColor.Text.primary)
                    
                    Text("\(profile.xp) / \(profile.nextLevelXP) XP")
                        .font(KPFont.body())
                        .foregroundColor(KPColor.Text.secondary)
                }
                
                HStack(spacing: KPSpacing.lg) {
                    statPill(icon: "bitcoinsign.circle.fill", value: "\(profile.coins)", color: KPColor.Accent.gold)
                    statPill(icon: "flame.fill", value: "\(profile.currentStreak)", color: KPColor.streak)
                }
            }
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            Text("Statistics")
                .font(KPFont.displaySmall())
                .fontWeight(.bold)
                .foregroundColor(KPColor.Text.primary)
            
            KPCard(background: .white) {
                VStack(spacing: KPSpacing.sm) {
                    statRow(label: "Games Played", value: "\(profile.gameRecords.count)")
                    Divider()
                    statRow(label: "Longest Streak", value: "\(profile.longestStreak)")
                    Divider()
                    statRow(label: "Badges Earned", value: "\(profile.badges.count)")
                }
            }
        }
    }
    
    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            Text("Badges")
                .font(KPFont.displaySmall())
                .fontWeight(.bold)
                .foregroundColor(KPColor.Text.primary)
            
            KPCard(background: .white) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: KPSpacing.md) {
                    ForEach(0..<8, id: \.self) { index in
                        badgeSlot(isEarned: index < profile.badges.count)
                    }
                }
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: KPSpacing.md) {
            Text("Settings")
                .font(KPFont.displaySmall())
                .fontWeight(.bold)
                .foregroundColor(KPColor.Text.primary)
            
            KPCard(background: .white) {
                VStack(spacing: KPSpacing.sm) {
                    settingToggle(
                        label: "Sound Effects",
                        icon: "speaker.wave.2.fill",
                        isOn: Binding(
                            get: { profile.soundEnabled },
                            set: { newValue in
                                profile.soundEnabled = newValue
                                SoundService.shared.setEnabled(newValue)
                                try? modelContext.save()
                            }
                        )
                    )
                    
                    Divider()
                    
                    settingToggle(
                        label: "Haptic Feedback",
                        icon: "hand.tap.fill",
                        isOn: Binding(
                            get: { profile.hapticsEnabled },
                            set: { newValue in
                                profile.hapticsEnabled = newValue
                                HapticsService.shared.setEnabled(newValue)
                                try? modelContext.save()
                            }
                        )
                    )
                    
                    Divider()
                    
                    settingToggle(
                        label: "Bot Taunts",
                        icon: "bubble.left.fill",
                        isOn: Binding(
                            get: { profile.tauntsEnabled },
                            set: { newValue in
                                profile.tauntsEnabled = newValue
                                try? modelContext.save()
                            }
                        )
                    )
                    
                    Divider()
                    
                    settingToggle(
                        label: "Eval Bar",
                        icon: "chart.bar.fill",
                        isOn: Binding(
                            get: { profile.evalBarEnabled },
                            set: { newValue in
                                profile.evalBarEnabled = newValue
                                try? modelContext.save()
                            }
                        )
                    )
                }
            }
        }
    }
    
    private func statPill(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: KPSpacing.xs) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .font(KPFont.bodyLarge())
                .fontWeight(.semibold)
                .foregroundColor(KPColor.Text.primary)
        }
        .padding(.horizontal, KPSpacing.md)
        .padding(.vertical, KPSpacing.xs)
        .background(
            Capsule()
                .fill(color.opacity(0.2))
        )
    }
    
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(KPFont.body())
                .foregroundColor(KPColor.Text.secondary)
            
            Spacer()
            
            Text(value)
                .font(KPFont.bodyLarge())
                .fontWeight(.semibold)
                .foregroundColor(KPColor.Text.primary)
        }
    }
    
    private func badgeSlot(isEarned: Bool) -> some View {
        ZStack {
            Circle()
                .fill(isEarned ? KPColor.Accent.gold.opacity(0.2) : KPColor.Card.border.opacity(0.3))
                .frame(width: 60, height: 60)
            
            Image(systemName: isEarned ? "star.fill" : "lock.fill")
                .font(.system(size: 24))
                .foregroundColor(isEarned ? KPColor.Accent.gold : KPColor.Text.secondary)
        }
        .saturation(isEarned ? 1.0 : 0.0)
        .opacity(isEarned ? 1.0 : 0.5)
    }
    
    private func settingToggle(label: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(KPColor.Brand.primary)
                .frame(width: 30)
            
            Text(label)
                .font(KPFont.body())
                .foregroundColor(KPColor.Text.primary)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(KPColor.Brand.primary)
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: PlayerProfile.self, inMemory: true)
}
