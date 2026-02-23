import SwiftUI
import SwiftData

final class DataManager: DataManagerProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func getPet() throws -> Pet {
        var descriptor = FetchDescriptor<Pet>()
        descriptor.fetchLimit = 1
        let pets = try context.fetch(descriptor)
        guard let pet = pets.first else {
            fatalError("No pet found")
        }
        return pet
    }
    
    func savePet(_ pet: Pet) {
        context.insert(pet)
    }
    
    func updatePet(_ pet: Pet,_ newPet: Pet)  {
        if pet.update(other: newPet){
            try? context.save()}
    }
    
    func deletePet(_ pet: Pet) {
        context.delete(pet)
    }
    
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
    
}
