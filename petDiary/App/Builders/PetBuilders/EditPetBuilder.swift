import Foundation
import SwiftData

struct EditPetBuilder {
    static func build(for pet: Pet) -> EditPetView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = PetRepository(dataManager: dataManager)
        let updatePetUseCase = UpdatePetUseCase(repository: repository)
        let viewModel = EditPetViewModel(
            update: updatePetUseCase,
            pet: pet)
        
        return EditPetView(viewModel: viewModel)
    }
}
