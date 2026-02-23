import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    private let getPet: GetPetUseCaseProtocol
    private let getReminders: GetReminderUseCaseProtocol
    
    @Published var pet: Pet?
    @Published var reminders: [Reminder] = []
    @Published var errorMessage: String?
    
    init(getPet: GetPetUseCaseProtocol,
         getReminders: GetReminderUseCaseProtocol) {
        self.getPet = getPet
        self.getReminders = getReminders
    }
    
    func loadData() {
        do{
            let pet = try getPet.execute()
            self.pet = pet
            self.reminders = try getReminders.execute(pet: pet)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
