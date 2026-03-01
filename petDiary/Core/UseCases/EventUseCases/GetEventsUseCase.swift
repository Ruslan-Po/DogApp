import Foundation

protocol GetEventsUseCaseProtocol {
    func execute(_ pet: Pet) throws -> [Event]
}

final class GetEventsUseCase: GetEventsUseCaseProtocol {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ pet: Pet) throws -> [Event] {
        let events = try repository.getAll(for: pet)
        return events
    }
}
