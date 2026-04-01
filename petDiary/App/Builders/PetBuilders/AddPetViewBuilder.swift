import Foundation
import SwiftData

struct AddPetViewBuilder {
    static func build(onSave: @escaping (UUID) -> Void) -> AddPetView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = PetRepository(dataManager: dataManager)
        let save = SavePetUseCase(repository: repository)
        let viewModel = AddPetViewModel(savePet: save)
        return AddPetView(viewModel: viewModel, onSave: onSave)
    }
}
