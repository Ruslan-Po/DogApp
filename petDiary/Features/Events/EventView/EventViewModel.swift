import Foundation
import Combine
import SwiftData


final class EventViewModel: ObservableObject {
    private let  saveEvent: SaveEventUseCaseProtocol
    private let  updateEvent: UpdateEventUseCaseProtocol
    private let pet: Pet
    
    @Published var events: [Event] = []
    
    init (saveEvent: SaveEventUseCaseProtocol,
          updateEvent: UpdateEventUseCaseProtocol,
          pet: Pet) {
        self.saveEvent = saveEvent
        self.updateEvent = updateEvent
        self.pet = pet
    }
    
    func addEvent() {
        
    }
}
