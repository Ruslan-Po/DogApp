import Foundation
import SwiftData

struct ReminderBuilder {
    
    private static func makeViewModel(for pet: Pet) -> ReminderViewModel {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = ReminderRepository(dataManager: dataManager)
        let petRepository = PetRepository(dataManager: dataManager)
        let save = SaveReminderUseCase(repository: repository)
        let update = UpdateReminderUseCase(repository: repository)
        let getPets = GetPetUseCase(repository: petRepository)
        return ReminderViewModel(
            saveReminder: save,
            updateReminder: update,
            getPets: getPets
        )
    }
    
    static func build(for pet: Pet) -> ReminderView {
        
        return ReminderView(viewModel: makeViewModel(for: pet), mode: .add(pet))
    }
    
    static func buildEdit(for reminder: Reminder, pet: Pet) -> ReminderView {
        ReminderView(viewModel: makeViewModel(for: pet), mode: .edit(reminder))
    }
}
