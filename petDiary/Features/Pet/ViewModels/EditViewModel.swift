import Foundation
import Combine

final class EditPetViewModel: ObservableObject {
    private let update: UpdatePetUseCaseProtocol
  
    @Published var pet: Pet?
    
    init(update: UpdatePetUseCaseProtocol, pet: Pet) {
        self.update = update
        self.pet =  pet
    }
    
    func updatePet(_ newData: Pet) {
        guard let oldPet = pet else {
            print("Don't have a pet to edit")
            return
        }
        update.execute(pet: oldPet, newData: newData)
    }
}
