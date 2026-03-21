import Foundation

final class ReminderRepository: ReminderRepositoryProtocol {
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func save(_ reminder: Reminder) {
        dataManager.saveReminder(reminder)
    }
    
    func delete(_ reminder: Reminder) {
        dataManager.deleteReminder(reminder)
    }
    
    func fetchAll() throws -> [Reminder] {
        let reminders = try dataManager.getReminders()
        return reminders
    }
    
    func update(_ reminder: Reminder,_ newReminder: Reminder) {
        dataManager.updateReminder(reminder,newReminder)
    }
}

