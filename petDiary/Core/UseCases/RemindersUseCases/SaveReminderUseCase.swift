import Foundation

protocol SaveReminderUseCaseProtocol {
    func save(_ reminder: Reminder, pet: Pet)
}

final class SaveReminderUseCase: SaveReminderUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    func save(_ reminder: Reminder, pet: Pet) {
        guard reminder.isRepeating, let interval = reminder.repeatInterval else {
            repository.save(pet: pet, reminder)
            return
        }
        
        let dates = generateDates(from: reminder.scheduleDate, interval: interval)
        let seriesId = UUID()
        
        for date in dates {
            let instance = Reminder(
                id: UUID(),
                pet: pet,
                title: reminder.title,
                category: reminder.category,
                scheduleDate: date,
                isRepeating: true,
                repeatInterval: interval,
                isEnable: true,
                doneTime: reminder.doneTime,
                doneCondition: false,
                seriesId: seriesId
            )
            repository.save(pet: pet, instance)
        }
    }
    
    private func generateDates(from start: Date, interval: RepeatInterval) -> [Date] {
        let calendar = Calendar.current
        let count: Int
        let component: Calendar.Component
        
        switch interval {
        case .daily:   count = 365; component = .day
        case .weekly:  count = 52;  component = .weekOfYear
        case .monthly: count = 12;  component = .month
        }
        
        return (0..<count).compactMap {
            calendar.date(byAdding: component, value: $0, to: start)
        }
    }
}

