import Foundation


protocol UpdatePetUseCaseProtocol {
    func execute(pet: Pet, newData: Pet)
}

final class UpdatePetUseCase: UpdatePetUseCaseProtocol {
    private let repository: PetRepositoryProtocol
    init(repository: PetRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(pet: Pet, newData: Pet) {
        repository.update(pet, newData)
    }
}
