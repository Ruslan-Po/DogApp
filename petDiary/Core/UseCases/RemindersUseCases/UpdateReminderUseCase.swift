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
        guard let seriesId = reminder.seriesId else {
            repository.update(reminder, newReminder)
            return
        }

        let all = (try? repository.fetchAll()) ?? []
        let series = all.filter { $0.seriesId == seriesId }

        for item in series {
            let updated = Reminder(
                id: item.id,
                pet: item.pet,
                title: newReminder.title,
                category: newReminder.category,
                scheduleDate: item.scheduleDate,
                isRepeating: item.isRepeating,
                repeatInterval: item.repeatInterval,
                isEnable: item.isEnable,
                doneTime: newReminder.doneTime,
                doneCondition: item.doneCondition,
                seriesId: seriesId
            )
            repository.update(item, updated)
        }
    }
}
