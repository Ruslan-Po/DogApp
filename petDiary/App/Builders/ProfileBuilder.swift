import Foundation
import SwiftData


struct ProfileBuilder {
    static  func build() -> ProfileView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = ReminderRepository(dataManager: dataManager)
        let getRemindersUseCase = GetRemindersUseCase(repository: repository)
        let viewModel = ProfileViewModel(getReminders: getRemindersUseCase)
        
        let view = ProfileView(viewModel: viewModel)
        return view
    }
}
