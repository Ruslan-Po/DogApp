import Foundation

protocol RemoveEventUseCaseProtocol {
    func execute(_ event: Event)
}

final class RemoveEventUseCase: RemoveEventUseCaseProtocol {
    private let repository: EventRepositoryProtocol
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ event: Event) {
        repository.delete(event)
    }
    
    
}
