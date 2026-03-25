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
    
    
    @Published var pets: [Pet]?
    @Published var selectedPet: Pet?
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
    
    func removePet(pet: Pet) throws {
        remove.execute(pet)
        _ = try getPet()
    }
    
    func removeReminder(_ reminder: Reminder)  {
        guard reminder.pet != nil else { return }
        deleteReminder.execute(reminder)
        reminders = reminders.filter {$0.id != reminder.id}
    }
    
    func removeEvent(_ event: Event) {
        removeEvent.execute(event)
    }
    
    func getPet() throws -> [Pet] {
        let result = try loadPet.execute()
        self.pets = result
        self.selectedPet = result.first
        self.reminders = result.first?.reminders ?? []
        return result
    }
    
    func loadReminders(){
        reminders = selectedPet?.reminders ?? []
    }
    
    func loadEvents() throws {
        events = try getEvents.execute()
    }
    
    func convertToEvent(for pet: Pet, _ reminder: Reminder) {
        let newEvent = convertReminder.execute(for: pet, reminder)
        saveEvent.execute(for: pet, newEvent)
    }
    
    func selectPet(_ pet: Pet) {
        self.selectedPet = pet
        self.reminders = pet.reminders
    }
}
