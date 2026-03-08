import Foundation

protocol GetEventsUseCaseProtocol {
    func execute() throws -> [Event]
}

final class GetEventsUseCase: GetEventsUseCaseProtocol {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() throws -> [Event] {
        let events = try repository.getAll()
        return events
    }
}
