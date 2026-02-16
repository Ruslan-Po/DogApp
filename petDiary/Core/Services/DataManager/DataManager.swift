import Foundation
import SwiftData


@MainActor
class DataManager {
    static let shared = DataManager()
    
    var modelContainer: ModelContainer
    var modelContext: ModelContext
    
    private init() {
        do{
            self.modelContainer = try ModelContainer(for: Pet.self,Event.self,Reminder.self)
            self.modelContext = ModelContext(modelContainer)
            self.modelContext.autosaveEnabled = true
        } catch {
            fatalError("\(error)")
        }
        
    }
    
}
