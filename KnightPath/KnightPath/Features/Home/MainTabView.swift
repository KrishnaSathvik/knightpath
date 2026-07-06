import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                PathMapView()
                    .tag(1)
                
                DailyPuzzlesView()
                    .tag(2)
                
                ProfileView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            customTabBar
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(index: 0, icon: "house.fill", label: "Home")
            tabButton(index: 1, icon: "map.fill", label: "Path")
            tabButton(index: 2, icon: "puzzlepiece.fill", label: "Puzzles")
            tabButton(index: 3, icon: "person.fill", label: "Profile")
        }
        .padding(.horizontal, KPSpacing.md)
        .padding(.vertical, KPSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: KPRadius.xxl)
                .fill(KPColor.Background.base)
                .shadow(color: .black.opacity(0.1), radius: 8, y: -2)
        )
        .padding(.horizontal, KPSpacing.md)
        .padding(.bottom, KPSpacing.sm)
    }
    
    private func tabButton(index: Int, icon: String, label: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
                HapticsService.shared.move()
            }
        } label: {
            VStack(spacing: KPSpacing.xxs) {
                ZStack {
                    if selectedTab == index {
                        Capsule()
                            .fill(KPColor.Brand.primary.opacity(0.2))
                            .frame(width: 60, height: 32)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(selectedTab == index ? KPColor.Brand.primary : KPColor.Text.secondary)
                }
                
                Text(label)
                    .font(KPFont.captionSmall())
                    .foregroundColor(selectedTab == index ? KPColor.Brand.primary : KPColor.Text.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: PlayerProfile.self, inMemory: true)
}
