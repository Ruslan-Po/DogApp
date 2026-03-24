import Foundation

protocol GetPetUseCaseProtocol {
    func execute() throws -> [Pet]
}

final class GetPetUseCase: GetPetUseCaseProtocol {
    private let repository: PetRepositoryProtocol
    
    init(repository: PetRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() throws -> [Pet] {
        try repository.fetchPets()
    }
}
