import Foundation
import SwiftData

struct ReminderBuilder{
    static func build(for pet: Pet) -> ReminderView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = ReminderRepository(dataManager: dataManager)
        let save = SaveReminderUseCase(repository: repository)
        let viewModel = ReminderViewModel(saveReminder: save, pet: pet)
        
        return ReminderView(viewModel: viewModel)
    }
}
