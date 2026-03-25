import Foundation

protocol ConvertReminderToEventUseCaseProtocol {
    func execute  (for pet: Pet, _ reminder: Reminder) -> Event
}

final class ConvertReminderToEventUseCase: ConvertReminderToEventUseCaseProtocol {
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(for pet: Pet,_ reminder: Reminder) -> Event {
        let event = Event(
            id: UUID(),
            pet: pet,
            category: reminder.category,
            title: reminder.title,
            date: reminder.doneTime,
            note: nil
    )
        return event
    }
}
