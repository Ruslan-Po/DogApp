import Foundation
import Combine

final class EditPetViewModel: ObservableObject {
    private let update: UpdatePetUseCaseProtocol
    private let load: GetPetUseCaseProtocol
    
    @Published var pet: Pet?
    
    init(update: UpdatePetUseCaseProtocol, load: GetPetUseCaseProtocol) {
        self.update = update
        self.load = load
        self.pet = try? load.execute() 
    }
    
    func updatePet(_ newData: Pet) {
        guard let oldPet = pet else {
            print("Don't have a pet to edit")
            return
        }
        update.execute(pet: oldPet, newData: newData)
    }
}
