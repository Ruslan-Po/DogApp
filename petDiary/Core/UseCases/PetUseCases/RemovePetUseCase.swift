import Foundation

protocol RemovePetUseCaseProtocol {
    func execute(_ pet: Pet)
}

final class RemovePetUseCase: RemovePetUseCaseProtocol {
    private var repository: PetRepositoryProtocol
    
    init(repository: PetRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ pet: Pet) {
        repository.removePet(pet: pet)
    }
}
