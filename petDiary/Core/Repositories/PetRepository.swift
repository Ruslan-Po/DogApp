import Foundation

final class PetRepository: PetRepositoryProtocol {
    private var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func fetchPets() throws -> Pet {
        let pet = try dataManager.getPet()
        return pet
    }
    
    func removePet(pet: Pet) {
        dataManager.deletePet(pet)
    }
    
    func addPet(_ pet: Pet) {
        dataManager.savePet(pet)
    }
    
    func update(_ pet: Pet,_ new: Pet ) {
        dataManager.updatePet(pet, new)
    }
}

