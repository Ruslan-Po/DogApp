import Foundation

protocol UpdateReminderUseCaseProtocol {
    func execute(_ reminder: Reminder, _ newReminder: Reminder)
}
final class UpdateReminderUseCase: UpdateReminderUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ reminder: Reminder, _ newReminder: Reminder) {
        repository.update(reminder, newReminder)
    }
}
