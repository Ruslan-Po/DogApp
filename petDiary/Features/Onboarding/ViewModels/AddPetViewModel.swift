import Foundation
import Combine

final class AddPetViewModel: ObservableObject {
    private  let savePet: SavePetUseCaseProtocol

    @Published var pet: Pet?
    
    init(savePet: SavePetUseCaseProtocol) {
        self.savePet = savePet
    }
    
    func save(pet: Pet){
        savePet.execute(pet)
    }
}

