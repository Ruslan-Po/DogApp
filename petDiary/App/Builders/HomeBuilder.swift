import Foundation
import SwiftData

struct HomeBuilder {
    static func build() -> HomeView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let petRepository = PetRepository(dataManager: dataManager)
        let remindersRepository = ReminderRepository(dataManager: dataManager)
        let eventRepository = EventRepository(dataManager: dataManager)
        let getPet = GetPetUseCase(repository: petRepository)
        let getReminders = GetReminderUseCase(repository: remindersRepository)
        let getEvents = GetEventsUseCase(repository: eventRepository)
        
        let viewModel = HomeViewModel(getPet: getPet,
                                      getReminders: getReminders,
                                      getEvents: getEvents)
        return HomeView(viewModel: viewModel)
    }
}

