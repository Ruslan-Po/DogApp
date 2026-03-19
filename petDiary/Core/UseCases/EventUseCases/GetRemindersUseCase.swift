import Foundation

protocol GetRemindersUseCaseProtocol {
    func execute() -> [Reminder]
}

struct GetRemindersUseCase: GetRemindersUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> [Reminder] {
        guard let reminders = try? repository.fetchAll() else { return [] }
        return reminders
    }
}
