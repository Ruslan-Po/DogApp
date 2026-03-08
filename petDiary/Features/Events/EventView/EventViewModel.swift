import Foundation
import Combine
import SwiftData


final class EventViewModel: ObservableObject {
    private let  saveEvent: SaveEventUseCaseProtocol
    private let  updateEvent: UpdateEventUseCaseProtocol

   // private let pet: Pet
    
    @Published var events: [Event] = []
    
    init (saveEvent: SaveEventUseCaseProtocol,
          updateEvent: UpdateEventUseCaseProtocol,
        //pet: Pet
    ) {
        self.saveEvent = saveEvent
        self.updateEvent = updateEvent
        //self.pet = pet
    }
    
    func addEvent(title: String,
                  category: EventCategory,
                  date: Date,
                  note: String?) {
        let event = Event(id: UUID(),
                          category: category,
                          title: title,
                          date: date)
        saveEvent.execute(event)
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
}
