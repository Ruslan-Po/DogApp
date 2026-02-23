import Foundation

protocol SavePetUseCaseProtocol {
    func execute(_ pet: Pet)
}

final class SavePetUseCase: SavePetUseCaseProtocol {
    private let repository: PetRepositoryProtocol
    
    init(repository: PetRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ pet: Pet) {
        repository.addPet(pet)
    }
}
