import Foundation
import SwiftData

struct CalendarBuilder {
    static func build() -> CalendarView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let reminderRepository = ReminderRepository(dataManager: dataManager)
        let eventsRepository = EventRepository(dataManager: dataManager)
        let getEvents = GetEventsUseCase(repository: eventsRepository)
        let getReminders = GetRemindersUseCase(repository: reminderRepository)
        let removeEvent = RemoveEventUseCase(repository: eventsRepository)
        let removeReminder = RemoveReminderUseCase(repository: reminderRepository)
  
        let viewModel = CalendarViewModel(getEvents: getEvents,
                                          getReminders: getReminders,
                                          removeReminders: removeReminder,
                                          removeEvent: removeEvent)
        
        return CalendarView(viewModel: viewModel)
    }
}
