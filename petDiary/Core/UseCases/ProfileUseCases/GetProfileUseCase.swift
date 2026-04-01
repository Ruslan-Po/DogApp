import Foundation


protocol GetProfileUseCaseProtocol {
    func execute() throws -> Profile
}

final class GetProfileUseCase: GetProfileUseCaseProtocol {
    let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() throws -> Profile {
        try repository.getProfile()
    }
}
