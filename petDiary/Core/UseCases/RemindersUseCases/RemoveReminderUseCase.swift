import Foundation

protocol RemoveReminderUseCaseProtocol {
    func execute(_ reminder: Reminder,)
}

final class RemoveReminderUseCase: RemoveReminderUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ reminder: Reminder)  {
        repository.delete(reminder)
    }
}
