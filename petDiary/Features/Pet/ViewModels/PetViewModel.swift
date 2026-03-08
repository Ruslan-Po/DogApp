import Foundation
import Combine
import SwiftData

final class PetViewModel: ObservableObject {
    private var loadPet: GetPetUseCaseProtocol
    private var remove: RemovePetUseCaseProtocol
    private var saveReminder: SaveReminderUseCaseProtocol
    private var deleteReminder: RemoveReminderUseCaseProtocol
    private var saveEvent: SaveEventUseCaseProtocol
    private var removeEvent: RemoveEventUseCaseProtocol
    private var convertReminder: ConvertReminderToEventUseCaseProtocol
    private var getEvents: GetEventsUseCaseProtocol
    
    
    @Published var pet: Pet?
    @Published var reminders: [Reminder] = []
    @Published var events: [Event] = []
    
    init(getPet: GetPetUseCaseProtocol,
         remove: RemovePetUseCaseProtocol,
         saveReminder: SaveReminderUseCaseProtocol,
         deleteReminder: RemoveReminderUseCaseProtocol,
         convertReminder: ConvertReminderToEventUseCaseProtocol,
         saveEvent: SaveEventUseCaseProtocol,
         removeEvent: RemoveEventUseCaseProtocol,
        getEvents: GetEventsUseCaseProtocol) {
        self.loadPet = getPet
        self.remove = remove
        self.saveReminder = saveReminder
        self.deleteReminder = deleteReminder
        self.convertReminder = convertReminder
        self.saveEvent = saveEvent
        self.removeEvent = removeEvent
        self.getEvents = getEvents
    }
    
    func removePet() throws {
        guard let pet else { return }
        remove.execute(pet)
    }
    
    func removeReminder(_ reminder: Reminder)  {
       guard let pet = reminder.pet else { return }
        deleteReminder.execute(reminder: reminder, for: pet)
        reminders = reminders.filter {$0.id != reminder.id}
    }
    
    func removeEvent(_ event: Event) {
        removeEvent.execute(event)
    }
    
    func getPet() throws -> Pet {
        let result = try loadPet.execute()
        self.pet = result
        self.reminders = result.reminders
        return result
    }
    
    func loadReminders(){
        reminders = pet?.reminders ?? []
    }
    
    func loadEvents() throws {
        events = try getEvents.execute()
    }
    
    func convertToEvent(_ reminder: Reminder) {
        let newEvent = convertReminder.execute(reminder)
        saveEvent.execute(newEvent)
    }
}
