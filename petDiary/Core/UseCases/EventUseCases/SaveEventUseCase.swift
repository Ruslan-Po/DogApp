import Foundation

protocol SaveEventUseCaseProtocol {
    func execute(_ event: Event,_ pet: Pet)
}

final class SaveEventUseCase: SaveEventUseCaseProtocol {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    func execute(_ event: Event, _ pet: Pet) {
        repository.save(event, for: pet)
    }
}
