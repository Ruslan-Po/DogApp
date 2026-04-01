import Foundation

protocol RemoveSingleReminderUseCaseProtocol {
    func execute(_ reminder: Reminder)
}

final class RemoveSingleReminderUseCase: RemoveSingleReminderUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol

    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ reminder: Reminder) {
        repository.delete(reminder)
    }
}
