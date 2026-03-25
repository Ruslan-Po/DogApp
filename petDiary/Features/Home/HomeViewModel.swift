import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    private let getPet: GetPetUseCaseProtocol
    private let getReminders: GetRemindersUseCaseProtocol
    private let getEvents: GetEventsUseCaseProtocol
    private var removeEvent: RemoveEventUseCaseProtocol
    private var removeReminder: RemoveReminderUseCaseProtocol
    private var convertReminderToEvent: ConvertReminderToEventUseCaseProtocol
    
    @Published var pet: [Pet]?
    @Published var reminders: [Reminder] = []
    @Published var errorMessage: String?
    @Published var events: [Event] = []
    
    init(getPet: GetPetUseCaseProtocol,
         getReminders: GetRemindersUseCaseProtocol,
        getEvents: GetEventsUseCaseProtocol,
         removeEvent: RemoveEventUseCaseProtocol,
         removeReminder: RemoveReminderUseCaseProtocol,
    convertReminderToEvent: ConvertReminderToEventUseCaseProtocol) {
        self.getPet = getPet
        self.getReminders = getReminders
        self.getEvents = getEvents
        self.removeEvent = removeEvent
        self.removeReminder = removeReminder
        self.convertReminderToEvent = convertReminderToEvent
    }
    
    func loadData() {
        do{
            let pet = try getPet.execute()
            self.pet = pet
            self.reminders = try getReminders.execute()
            self.events = try getEvents.execute()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }    
}
