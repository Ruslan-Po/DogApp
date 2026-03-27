import Foundation
import Combine
import SwiftData


final class EventViewModel: ObservableObject {
    private let  saveEvent: SaveEventUseCaseProtocol
    private let  updateEvent: UpdateEventUseCaseProtocol
    private let getPet: GetPetUseCaseProtocol
    
    @Published var pets: [Pet]? = nil
    @Published var events: [Event] = []
    
    init (saveEvent: SaveEventUseCaseProtocol,
          updateEvent: UpdateEventUseCaseProtocol,
          getPet: GetPetUseCaseProtocol
          
    ) {
        self.saveEvent = saveEvent
        self.updateEvent = updateEvent
        self.getPet = getPet
    }
    
    func addEvent(title: String,
                  category: EventCategory,
                  date: Date,
                  note: String?,
                  pet: Pet) {
        let event = Event(id: UUID(),
                          pet: pet,
                          category: category,
                          title: title,
                          date: date)
        saveEvent.execute(for: pet, event)
    }
    
    func updateEvent(_ newEvent: Event,
                     title: String,
                     date: Date,
                     note: String?) {
        let event = Event(id: newEvent.id,
                          category: newEvent.category,
                          title: title,
                          date: date)
        updateEvent.execute(event, newEvent)
    }
    
    func loadPets() {
        let pets = try? getPet.execute()
        self.pets = pets
    }
}
