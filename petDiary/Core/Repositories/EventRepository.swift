import Foundation

final class EventRepository: EventRepositoryProtocol {
    private var dataManager: DataManagerProtocol
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func save(for pet: Pet, _ event: Event) {
        dataManager.saveEvent(for: pet, event)
    }
    
    func delete(_ event: Event) {
        dataManager.deleteEvent(event)
    }
    
    func getAll() throws -> [Event] {
        let events = try dataManager.getEvents()
        return events
    }
    
    func update(_ event: Event, _ newEvent: Event) {
        dataManager.updateEvent(event, newEvent)
    }
}
