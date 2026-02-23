import Foundation
import SwiftData

struct HomeBuilder {
    static func build() -> HomeView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let petRepository = PetRepository(dataManager: dataManager)
        let remindersRepository = ReminderRepository(dataManager: dataManager)
        let getPet = GetPetUseCase(repository: petRepository)
        let getReminders = GetReminderUseCase(repository: remindersRepository)
  
        let viewModel = HomeViewModel(getPet: getPet,
                                      getReminders: getReminders)
        return HomeView(viewModel: viewModel)
    }
}

