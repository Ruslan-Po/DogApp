import Foundation
import Combine
import SwiftData

final class ReminderViewModel: ObservableObject{
    private let saveReminder: SaveReminderUseCaseProtocol
    private let updateReminder: UpdateReminderUseCaseProtocol
    private let getPets: GetPetUseCaseProtocol
    
    @Published var pets: [Pet]? = nil

    @Published var reminders: [Reminder] = []
    
    init(saveReminder: SaveReminderUseCaseProtocol,
         updateReminder: UpdateReminderUseCaseProtocol,
         getPets: GetPetUseCaseProtocol) {
        self.saveReminder = saveReminder
        self.updateReminder = updateReminder
        self.getPets = getPets
    }
    
    func addReminder(title: String,
                     category: EventCategory,
                     isRepeating: Bool,
                     scheduleDate: Date,
                     doneTime: Date,
                     isDone: Bool,
                     pet: Pet) {
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
                        isDone: Bool)
    {
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
    
    func loadPets() {
        let pets = try? getPets.execute()
        self.pets = pets
    }
}
