import Foundation

final class ReminderRepository: ReminderRepositoryProtocol {
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func save(_ reminder: Reminder, for pet: Pet) {
        dataManager.saveReminder(reminder, for: pet)
    }
    
    func delete(_ reminder: Reminder, for pet: Pet) {
        dataManager.deleteReminder(reminder, for: pet)
    }
    
    func fetchAll() throws -> [Reminder] {
        let reminders = try dataManager.getReminders()
        return reminders
    }
    
    func update(_ reminder: Reminder,_ newReminder: Reminder) {
        dataManager.updateReminder(reminder,newReminder)
    }
}

