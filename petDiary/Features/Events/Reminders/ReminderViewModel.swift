import Foundation
import Combine
import SwiftData

final class ReminderViewModel: ObservableObject{
    private let saveReminder: SaveReminderUseCaseProtocol
    private let updateReminder: UpdateReminderUseCaseProtocol
    
    private let pet: Pet
    
    @Published var reminders: [Reminder] = []
    
    init(saveReminder: SaveReminderUseCaseProtocol,
         pet: Pet,
         updateReminder: UpdateReminderUseCaseProtocol) {
        self.saveReminder = saveReminder
        self.pet = pet
        self.reminders = pet.reminders
        self.updateReminder = updateReminder
    }
    
    func addReminder(title: String,
                     category: EventCategory,
                     isRepeating: Bool,
                     scheduleDate: Date,
                     doneTime: Date,
                     isDone: Bool) {
        let reminder = Reminder(
            id: UUID(),
            pet: pet,
            title: title,
            category: category,
            scheduleDate: scheduleDate,
            isRepeating: isRepeating,
            isEnable: true,
            doneTime: doneTime,
            doneCondition: isDone)
        
        saveReminder.save(reminder,pet: pet)
        reminders = pet.reminders
    }
    
    func updateReminder(_ reminder: Reminder,
                        title: String,
                        category: EventCategory,
                        isRepeating: Bool,
                        scheduleDate: Date,
                        doneTime: Date,
                        isDone: Bool) {
        let updated = Reminder(
            id: reminder.id,
            pet: reminder.pet,
            title: title,
            category: category,
            scheduleDate: scheduleDate,
            isRepeating: isRepeating,
            isEnable: reminder.isEnable,
            doneTime: doneTime,
            doneCondition: isDone
        )
        updateReminder.execute(reminder, updated)
    }
}
