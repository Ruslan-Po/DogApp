import Foundation

final class EventRepository: EventRepositoryProtocol {
    private var dataManager: DataManagerProtocol
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func save(_ event: Event, for pet: Pet) {
        dataManager.saveEvent(event, for: pet)
    }
    
    func delete(event: Event, for pet: Pet) {
        dataManager.deleteEvent(event, for: pet)
    }
    
    func getAll(for pet: Pet) throws -> [Event] {
        let events = try dataManager.getEvents(for: pet)
        return events
    }
    
    func update(_ event: Event, _ newEvent: Event) {
        dataManager.updateEvent(event, newEvent)
    }
}
