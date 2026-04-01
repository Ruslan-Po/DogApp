import Foundation


protocol UpdatePetUseCaseProtocol {
    func execute(pet: Pet)
}


final class UpdatePetUseCase: UpdatePetUseCaseProtocol {
    private let repository: PetRepositoryProtocol
    init(repository: PetRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(pet: Pet) {
           repository.update(pet)
       }
}
