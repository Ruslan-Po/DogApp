import SwiftData

extension ModelContainer {
    static var appContainer: ModelContainer = {
        do {
            return try ModelContainer(
                for: Pet.self,
                Event.self,
                Reminder.self,
                Profile.self,
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}
 
