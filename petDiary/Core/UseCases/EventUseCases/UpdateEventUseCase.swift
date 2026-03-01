import Foundation

protocol UpdateEventUseCaseProtocol {
    func execute(_ event: Event,_ newEvent: Event)
}

final class UpdateEventUseCase: UpdateEventUseCaseProtocol {
    
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ event: Event, _ newEvent: Event) {
        repository.update(event, newEvent)
    }
}
