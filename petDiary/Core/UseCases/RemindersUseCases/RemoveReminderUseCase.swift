import Foundation

protocol RemoveReminderUseCaseProtocol {
    func execute(_ reminder: Reminder, from list: [Reminder])
}

final class RemoveReminderUseCase: RemoveReminderUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol

    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ reminder: Reminder, from list: [Reminder]) {
        guard let seriesId = reminder.seriesId else {
            repository.delete(reminder)
            return
        }

        list
            .filter { $0.seriesId == seriesId && $0.scheduleDate >= reminder.scheduleDate }
            .forEach { repository.delete($0) }
    }
}
