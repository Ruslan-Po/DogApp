import SwiftUI
import SwiftData

@main
struct PetDiaryApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(
                for: Pet.self,
                Event.self,
                Reminder.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingView().modelContainer(modelContainer)
        }
    }
}
