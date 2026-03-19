import Foundation

protocol ReminderRepositoryProtocol{
    func save(_ reminder: Reminder, for pet: Pet)
    func delete(_ reminder: Reminder, for pet: Pet)
    func fetchAll() throws -> [Reminder]
    func update(_ reminder: Reminder,_ newReminder: Reminder)
}

