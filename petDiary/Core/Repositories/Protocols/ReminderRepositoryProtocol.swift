import Foundation

protocol ReminderRepositoryProtocol{
    func save(_ reminder: Reminder)
    func delete(_ reminder: Reminder)
    func fetchAll() throws -> [Reminder]
    func update(_ reminder: Reminder,_ newReminder: Reminder)
}

