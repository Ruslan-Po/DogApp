import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    private let getPet: GetPetUseCaseProtocol
    private let getReminders: GetRemindersUseCaseProtocol
    private let getEvents: GetEventsUseCaseProtocol
    private let addReminder: SaveReminderUseCaseProtocol
    private let addEvent: SaveEventUseCaseProtocol
    private var removeEvent: RemoveEventUseCaseProtocol
    private var removeReminder: RemoveReminderUseCaseProtocol
    private var convertReminderToEvent: ConvertReminderToEventUseCaseProtocol
    
    @Published var pet: [Pet]?
    @Published var reminders: [Reminder] = []
    @Published var errorMessage: String?
    @Published var events: [Event] = []
    @Published var selectedPet: Pet?
    @Published var filterPetId: UUID? = nil
    
    init(getPet: GetPetUseCaseProtocol,
         getReminders: GetRemindersUseCaseProtocol,
         getEvents: GetEventsUseCaseProtocol,
         removeEvent: RemoveEventUseCaseProtocol,
         removeReminder: RemoveReminderUseCaseProtocol,
         convertReminderToEvent: ConvertReminderToEventUseCaseProtocol,
         addReminder: SaveReminderUseCaseProtocol,
         addEvent: SaveEventUseCaseProtocol) {
        self.getPet = getPet
        self.getReminders = getReminders
        self.getEvents = getEvents
        self.removeEvent = removeEvent
        self.removeReminder = removeReminder
        self.convertReminderToEvent = convertReminderToEvent
        self.addEvent = addEvent
        self.addReminder = addReminder
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
    
    func removeReminder(_ reminder: Reminder)  {
        guard reminder.pet != nil else { return }
        removeReminder.execute(reminder)
        withAnimation {
            reminders = reminders.filter {$0.id != reminder.id}
        }
    }
    
    func removeEvent(_ event: Event) {
        print("Before delete: \(events.count)")
        removeEvent.execute(event)
        withAnimation {
            events = events.filter { $0.id != event.id }
        }
        print("After delete: \(events.count)")
    }
    
    
    func loadReminders(){
        reminders = selectedPet?.reminders ?? []
    }
    
    func loadEvents() throws {
        events = try getEvents.execute()
    }
    
    func convertToEvent(for pet: Pet, _ reminder: Reminder) {
        let newEvent = convertReminderToEvent.execute(for: pet, reminder)
        addEvent.execute(for: pet, newEvent)
    }
    
    func selectPet(_ pet: Pet) {
        self.selectedPet = pet
        self.reminders = pet.reminders
    }
    
    var filteredEvents: [Event] {
        guard let filterPetId else { return events }
        return events.filter { $0.pet?.id == filterPetId }
    }

    var filteredReminders: [Reminder] {
        guard let filterPetId else { return reminders }
        return reminders.filter { $0.pet?.id == filterPetId }
    }

    var filterPet: Pet? {
        guard let filterPetId else { return nil }
        return pet?.first { $0.id == filterPetId }
    }
}
