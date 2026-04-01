import Foundation
import Combine

final class EditPetViewModel: ObservableObject {
    private let update: UpdatePetUseCaseProtocol
    @Published var pet: Pet?
    
    init(update: UpdatePetUseCaseProtocol, pet: Pet) {
        self.update = update
        self.pet = pet
    }
    
    func save() {
        guard let pet = pet else { return }
        update.execute(pet: pet)
    }
}
