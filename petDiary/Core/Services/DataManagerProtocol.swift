import Foundation

protocol DataManagerProtocol{
    // MARK: - Pets
    func getPet() throws -> Pet
    func savePet(_ pet: Pet)
    func updatePet(_ pet: Pet,_ newPet: Pet)
    func deletePet(_ pet: Pet)
    
    // MARK: - Reminders
    func saveReminder(_ reminder: Reminder, for pet: Pet)
    func deleteReminder(_ reminder: Reminder, for pet: Pet)
    func getReminders(for pet: Pet) throws -> [Reminder]
    func updateReminder(_ reminder: Reminder, _ newReminder: Reminder)
}


