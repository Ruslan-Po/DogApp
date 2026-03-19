import Foundation

protocol GetReminderUseCaseProtocol{
    func execute(pet: Pet) throws -> [Reminder]
}


final class GetReminderUseCase: GetReminderUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(pet: Pet) throws -> [Reminder] {
       let reminders = try repository.fetchAll()
        return reminders
    }
}
