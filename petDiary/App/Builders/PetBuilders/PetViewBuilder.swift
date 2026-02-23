import Foundation
import SwiftData

struct PetViewBuilder {
    static func build() -> PetView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = PetRepository(dataManager: dataManager)
        let reminderRepository = ReminderRepository(dataManager: dataManager)
        let get = GetPetUseCase(repository: repository)
        let remove = RemovePetUseCase(repository: repository)
        let removeReminder = RemoveReminderUseCase(repository: reminderRepository)
        let saveReminder = SaveReminderUseCase(repository: reminderRepository)
        let viewModel = PetViewModel(getPet: get,
                                     remove: remove,
                                     saveReminder: saveReminder,
                                     deleteReminder: removeReminder)
        
        return PetView(viewModel: viewModel)
    }
}
