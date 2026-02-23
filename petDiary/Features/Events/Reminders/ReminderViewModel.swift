import Foundation
import Combine
import SwiftData

final class ReminderViewModel: ObservableObject{
    private let saveReminder: SaveReminderUseCaseProtocol
    private let pet: Pet
    
    @Published var reminders: [Reminder] = []
    
    init(saveReminder: SaveReminderUseCaseProtocol,
         pet: Pet) {
        self.saveReminder = saveReminder
        self.pet = pet
        self.reminders = pet.reminders
    }
    
    func addReminder(title: String,
                     category: EventCategory,
                     isRepeating: Bool) {
        let reminder = Reminder(
            id: UUID(),
            pet: pet,
            title: title,
            category: category,
            isRepeating: isRepeating,
            isEnable: true)
        
        saveReminder.save(reminder,pet: pet)
        reminders = pet.reminders
    }
}
