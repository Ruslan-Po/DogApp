import Foundation

protocol GetRemindersUseCaseProtocol{
    func execute() throws -> [Reminder]
}

final class GetRemindersUseCase: GetRemindersUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() throws -> [Reminder] {
       let reminders = try repository.fetchAll()
        return reminders
    }
}
