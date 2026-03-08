import SwiftUI
import SwiftData

final class DataManager: DataManagerProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    //MARK: - Pet
    
    func getPet() throws -> Pet {
        var descriptor = FetchDescriptor<Pet>()
        descriptor.fetchLimit = 1
        let pets = try context.fetch(descriptor)
        guard let pet = pets.first else {
                throw DataManagerError.petNotFound
            }
        return pet
    }
    
    func savePet(_ pet: Pet) {
        context.insert(pet)
        try? context.save()
    }
    
    func updatePet(_ pet: Pet,_ newPet: Pet)  {
        if pet.update(other: newPet){
            try? context.save()}
    }
    
    func deletePet(_ pet: Pet) {
        context.delete(pet)
    }
    
    
    //MARK: - Reiminders
    func saveReminder(_ reminder: Reminder, for pet: Pet) {
        reminder.pet = pet
        context.insert(reminder)
    }
    
    func deleteReminder(_ reminder: Reminder, for pet: Pet) {
        context.delete(reminder)
    }
    
    func getReminders(for pet: Pet)  -> [Reminder] {
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
    func saveEvent(_ event: Event) {

        context.insert(event)
    }
    
    func deleteEvent(_ event: Event) {
        context.delete(event)
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
}
