import Foundation
import SwiftData


protocol PetRepository {
    func getPet() -> Pet?
    func createPet(_ pet: Pet) throws
    func updatePet(_ pet: Pet) throws
    func deletePet() throws
}

protocol EventRepository {
    func getAllEvents() -> [Event]
    func getEventForDate(_ date: Date) -> [Event]
    func createEvent(_ event: Event) throws
    func updateEvent(_ event: Event) throws
    func deleteEvent(_ event: Event) throws
}

protocol ReminderRepository {
    func getAllReminders() -> [Reminder]
    func getActiveReminders() -> [Reminder]
    func createReminder(_ reminder: Reminder) throws
    func updateReminder(_ reminder: Reminder) throws
    func deleteReminder(_ reminder: Reminder) throws
}


