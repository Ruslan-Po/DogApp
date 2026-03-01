import Foundation

protocol RemoveEventUseCaseProtocol {
    func execute(_ event: Event,_ pet: Pet)
}

final class RemoveEventUseCase: RemoveEventUseCaseProtocol {
    private let repository: EventRepositoryProtocol
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ event: Event, _ pet: Pet) {
        repository.delete(event: event, for: pet)
    }
}
