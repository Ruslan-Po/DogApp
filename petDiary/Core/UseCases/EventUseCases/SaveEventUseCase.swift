import Foundation

protocol SaveEventUseCaseProtocol {
    func execute(for pet: Pet,_ event: Event)
}

final class SaveEventUseCase: SaveEventUseCaseProtocol {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    func execute(for pet: Pet,_ event: Event) {
        repository.save(for: pet, event)
    }
}
