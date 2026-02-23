import Foundation

protocol RemoveReminderUseCaseProtocol {
    func execute(reminder: Reminder, for pet: Pet)
}

final class RemoveReminderUseCase: RemoveReminderUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(reminder: Reminder, for pet: Pet)  {
        repository.delete(reminder, for: pet)
    }
}
