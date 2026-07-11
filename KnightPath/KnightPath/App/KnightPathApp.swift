import SwiftUI
import SwiftData

@main
struct KnightPathApp: App {
    @State private var showSplash = true
    @State private var showOnboarding = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PlayerProfile.self,
            BotProgress.self,
            GameRecord.self,
            PuzzleProgress.self,
            Badge.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .modelContainer(sharedModelContainer)
                    .opacity(showSplash || showOnboarding ? 0 : 1)
                
                if showSplash {
                    SplashView(isPresented: $showSplash)
                        .transition(.opacity)
                        .onDisappear {
                            if shouldShowOnboarding() {
                                showOnboarding = true
                            }
                        }
                }
                
                if showOnboarding {
                    OnboardingView(isPresented: $showOnboarding)
                        .transition(.opacity)
                }
            }
        }
    }
    
    private func shouldShowOnboarding() -> Bool {
        !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}
