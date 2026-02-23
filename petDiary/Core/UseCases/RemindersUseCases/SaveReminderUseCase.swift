import Foundation

protocol SaveReminderUseCaseProtocol {
    func save(_ reminder: Reminder, pet: Pet)
}

final class SaveReminderUseCase: SaveReminderUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    func save(_ reminder: Reminder,pet: Pet) {
        repository.save(reminder, for: pet)
    }
}

