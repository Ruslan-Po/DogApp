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
    private let removeSingleReminder: RemoveSingleReminderUseCaseProtocol
    private let getProfile: GetProfileUseCaseProtocol
    
    @Published var pet: [Pet]?
    @Published var reminders: [Reminder] = []
    @Published var errorMessage: String?
    @Published var events: [Event] = []
    @Published var selectedPet: Pet?
    @Published var filterPetId: UUID? = nil
    @Published var autoConvertEnabled: Bool = false
    private var autoConvertTimer: AnyCancellable?
    
    
    
    init(getPet: GetPetUseCaseProtocol,
         getReminders: GetRemindersUseCaseProtocol,
         getEvents: GetEventsUseCaseProtocol,
         removeEvent: RemoveEventUseCaseProtocol,
         removeReminder: RemoveReminderUseCaseProtocol,
         convertReminderToEvent: ConvertReminderToEventUseCaseProtocol,
         addReminder: SaveReminderUseCaseProtocol,
         addEvent: SaveEventUseCaseProtocol,
         removeSingleReminder: RemoveSingleReminderUseCaseProtocol,
         getProfile: GetProfileUseCaseProtocol) {
        self.getPet = getPet
        self.getReminders = getReminders
        self.getEvents = getEvents
        self.removeEvent = removeEvent
        self.removeReminder = removeReminder
        self.convertReminderToEvent = convertReminderToEvent
        self.addEvent = addEvent
        self.addReminder = addReminder
        self.removeSingleReminder = removeSingleReminder
        self.getProfile = getProfile
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
    
    func removeReminder(_ reminder: Reminder) {
        guard reminder.pet != nil else { return }
        removeReminder.execute(reminder, from: reminders)
        withAnimation {
            if let seriesId = reminder.seriesId {
                reminders = reminders.filter {
                    !($0.seriesId == seriesId && $0.scheduleDate >= reminder.scheduleDate)
                }
            } else {
                reminders = reminders.filter { $0.id != reminder.id }
            }
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
    
    private func updateAutoConvertTimer() {
        autoConvertTimer?.cancel()
        guard autoConvertEnabled else { return }
        
        autoConvertTimer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.autoConvertExpiredReminders()
            }
    }
    
    private func autoConvertExpiredReminders() {
        let expired = reminders.filter {
            !$0.doneCondition && $0.scheduleDate <= Date()
        }
        
        for reminder in expired {
            guard let pet = reminder.pet else { continue }
            if let event = convertReminderToEvent.execute(for: pet, reminder, autoConvert: true) {
                addEvent.execute(for: pet, event)
            }
            completeReminder(reminder)
        }
        
        if !expired.isEmpty {
            try? loadEvents()
        }
    }
    
    
    func convertToEvent(for pet: Pet, _ reminder: Reminder) {
            if let event = convertReminderToEvent.execute(for: pet, reminder, autoConvert: false) {
                addEvent.execute(for: pet, event)
            }
        }
    
    func completeReminder(_ reminder: Reminder) {
        guard reminder.pet != nil else { return }
        removeSingleReminder.execute(reminder)
        withAnimation {
            reminders = reminders.filter { $0.id != reminder.id }
        }
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
        let all = filterPetId == nil
        ? reminders
        : reminders.filter { $0.pet?.id == filterPetId }
        
        let single = all.filter { $0.seriesId == nil }
        
        let seriesNearest: [Reminder] = Dictionary(
            grouping: all.filter { $0.seriesId != nil },
            by: { $0.seriesId! }
        )
            .compactMap { _, items in
                items
                    .filter { !$0.doneCondition }
                    .sorted { $0.scheduleDate < $1.scheduleDate }
                    .first
            }
        
        return (single + seriesNearest)
            .sorted { $0.scheduleDate < $1.scheduleDate }
    }
    
    var filterPet: Pet? {
        guard let filterPetId else { return nil }
        return pet?.first { $0.id == filterPetId }
    }
}
