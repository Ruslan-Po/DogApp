import Foundation
import Combine

final class CalendarViewModel: ObservableObject {
    private let getEvents: GetEventsUseCaseProtocol
    private let getReminders: GetRemindersUseCaseProtocol
    private let removeReminder: RemoveReminderUseCaseProtocol
    private let removeEvent: RemoveEventUseCaseProtocol
    
    init(getEvents: GetEventsUseCaseProtocol,
         getReminders: GetRemindersUseCaseProtocol,
         removeReminders: RemoveReminderUseCaseProtocol,
        removeEvent: RemoveEventUseCaseProtocol) {
        self.getEvents = getEvents
        self.getReminders = getReminders
        self.removeEvent = removeEvent
        self.removeReminder = removeReminders
    }
    
    @Published var events: [Event] = []
    @Published var reminders: [Reminder] = []
    
}
