import Foundation

protocol PetRepositoryProtocol {
    func fetchPets() throws -> [Pet]
    func removePet(pet: Pet)
    func addPet(_ pet: Pet)
    func update(_ pet: Pet,_ new: Pet)
}

