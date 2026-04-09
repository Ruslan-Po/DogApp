import SwiftUI
import SwiftData

@main
struct PetDiaryApp: App {
    @StateObject private var languageManager = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            OnboardingCoordinator()
                .modelContainer(.appContainer)
                .environmentObject(languageManager)
                .id(languageManager.current)
        }
    }
}
