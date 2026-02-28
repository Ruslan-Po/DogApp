import Foundation
import SwiftData

struct ReminderBuilder {
    
    private static func makeViewModel(for pet: Pet) -> ReminderViewModel {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = ReminderRepository(dataManager: dataManager)
        let save = SaveReminderUseCase(repository: repository)
        let update = UpdateReminderUseCase(repository: repository)
        return ReminderViewModel(saveReminder: save, pet: pet, updateReminder: update)
    }
    
    static func build(for pet: Pet) -> ReminderView {
        ReminderView(viewModel: makeViewModel(for: pet), mode: .add)
    }
    
    static func buildEdit(for reminder: Reminder, pet: Pet) -> ReminderView {
        ReminderView(viewModel: makeViewModel(for: pet), mode: .edit(reminder))
    }
}
