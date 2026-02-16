import SwiftUI
import SwiftData

@main
struct PetDiaryApp: App {
    let dataManager = DataManager.shared
    var body: some Scene {
        WindowGroup {
            Coordinator().modelContainer(dataManager.modelContainer)
        }
    }
}
