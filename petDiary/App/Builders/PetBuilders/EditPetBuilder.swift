import Foundation
import SwiftData

struct EditPetBuilder {
    static func build() -> EditPetView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = PetRepository(dataManager: dataManager)
        let getPetUseCase = GetPetUseCase(repository: repository)
        let updatePetUseCase = UpdatePetUseCase(repository: repository)
        let viewModel = EditPetViewModel(
            update: updatePetUseCase,
            load: getPetUseCase
        )
        
        return EditPetView(viewModel: viewModel)
    }
}
