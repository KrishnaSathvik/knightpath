import SwiftUI

@main
struct KnightPathApp: App {
    var body: some Scene {
        WindowGroup {
            BotGameView(bot: BotRoster.rookieRyan)
        }
    }
}
