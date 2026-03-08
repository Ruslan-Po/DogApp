import Foundation

protocol SaveEventUseCaseProtocol {
    func execute(_ event: Event)
}

final class SaveEventUseCase: SaveEventUseCaseProtocol {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    func execute(_ event: Event) {
        repository.save(event)
    }
}
