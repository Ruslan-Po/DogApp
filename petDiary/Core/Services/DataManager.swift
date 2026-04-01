import SwiftUI
import SwiftData

final class DataManager: DataManagerProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    //MARK: - Pet
    
    func getPet() throws -> [Pet] {
        let descriptor = FetchDescriptor<Pet>()
        let pets = try context.fetch(descriptor)
        return pets
    }
    
    func savePet(_ pet: Pet) {
        context.insert(pet)
        try? context.save()
    }
    
    func updatePet(_ pet: Pet) {
        try? context.save()
    }
    
    func deletePet(_ pet: Pet) {
        context.delete(pet)
    }
    
    
    //MARK: - Reiminders
    func saveReminder(for pet: Pet,_ reminder: Reminder) {
        context.insert(reminder)
        try? context.save()
    }
    
    func deleteReminder(_ reminder: Reminder) {
        context.delete(reminder)
    }
    
    func getReminders()  -> [Reminder] {
        var reminders: [Reminder] = []
        
        let descriptor = FetchDescriptor<Reminder>(
            sortBy: [SortDescriptor(\Reminder.scheduleDate)]
        )
        do{
            reminders = try context.fetch(descriptor)
        } catch {
            print(error)
        }
        return reminders
    }
    
    func updateReminder(_ reminder: Reminder, _ newReminder: Reminder) {
        if reminder.update(other: newReminder) {
            try? context.save()
        }
    }
    
    //MARK: - Events
    func saveEvent(for pet: Pet, _ event: Event) {
        context.insert(event)
        try? context.save()
    }
    
    func deleteEvent(_ event: Event) {
        context.delete(event)
        try? context.save()
    }
    
    func getEvents() throws -> [Event] {
        var events: [Event] = []
        
        let descriptor = FetchDescriptor<Event>(
            sortBy: [SortDescriptor(\Event.date)]
        )
        do{
            events = try context.fetch(descriptor)
        } catch {
            print(error)
        }
        return events
    }
    
    func updateEvent(_ event: Event, _ newEvent: Event) {
        if event.update(other: newEvent) {
            try? context.save()
        }
    }
    
    //MARK: - Profile
    func getProfile() throws -> [Profile] {
        let descriptor = FetchDescriptor<Profile>()
        guard let user = try? context.fetch(descriptor) else { return [] }
        return user
    }
    
    func saveProfile(_ profile: Profile) {
        context.insert(profile)
        try? context.save()
    }
    
    func updateProfile(_ profile: Profile, _ newProfile: Profile) {
        if profile.update(other: newProfile) {
            try? context.save()
        }
    }
    
    func deleteProfile(_ profile: Profile) {
        context.delete(profile)
        try? context.save()
    }
    
}
