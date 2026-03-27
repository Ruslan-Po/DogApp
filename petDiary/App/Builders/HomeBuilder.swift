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
        let getReminders = GetRemindersUseCase(repository: remindersRepository)
        let getEvents = GetEventsUseCase(repository: eventRepository)
        let addEvent = SaveEventUseCase(repository: eventRepository)
        let addReminder = SaveReminderUseCase(repository: remindersRepository)
        let removeEvent = RemoveEventUseCase(repository: eventRepository)
        let removeReminder = RemoveReminderUseCase(repository: remindersRepository)
        let convertReminderToEvent = ConvertReminderToEventUseCase(repository: eventRepository)
        
        let viewModel = HomeViewModel(getPet: getPet,
                                      getReminders: getReminders,
                                      getEvents: getEvents,
                                      removeEvent: removeEvent,
                                      removeReminder: removeReminder,
                                      convertReminderToEvent: convertReminderToEvent,
                                      addReminder: addReminder,
                                      addEvent: addEvent)
        return HomeView(viewModel: viewModel)
    }
}

