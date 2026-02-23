import Foundation
import Combine
import SwiftData

final class PetViewModel: ObservableObject {
    private var loadPet: GetPetUseCaseProtocol
    private var remove: RemovePetUseCaseProtocol
    private var saveReminder: SaveReminderUseCaseProtocol
    private var deleteReminder: RemoveReminderUseCaseProtocol
    
    @Published var pet: Pet?
    @Published var reminders: [Reminder] = []
    
    init(getPet: GetPetUseCaseProtocol,
         remove: RemovePetUseCaseProtocol,
         saveReminder: SaveReminderUseCaseProtocol,
            deleteReminder: RemoveReminderUseCaseProtocol) {
        self.loadPet = getPet
        self.remove = remove
        self.saveReminder = saveReminder
        self.deleteReminder = deleteReminder
    }
    
    func removePet() throws {
        guard let pet else { return }
        remove.execute(pet)
    }
    
    func removeReminder(_ reminder: Reminder)  {
       guard let pet = reminder.pet else { return }
        deleteReminder.execute(reminder: reminder, for: pet)
        reminders = pet.reminders
    }
    
    func getPet() throws -> Pet {
        let result = try loadPet.execute()
        self.pet = result
        self.reminders = result.reminders
        return result
    }
    
    func loadReminders(){
        reminders = pet?.reminders ?? []
    }
}
