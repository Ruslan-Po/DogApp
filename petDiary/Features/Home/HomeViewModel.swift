import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    private let getPet: GetPetUseCaseProtocol
    private let getReminders: GetRemindersUseCaseProtocol
    private let getEvents: GetEventsUseCaseProtocol
    
    @Published var pet: [Pet]?
    @Published var reminders: [Reminder] = []
    @Published var errorMessage: String?
    @Published var events: [Event] = []
    
    init(getPet: GetPetUseCaseProtocol,
         getReminders: GetRemindersUseCaseProtocol,
        getEvents: GetEventsUseCaseProtocol) {
        self.getPet = getPet
        self.getReminders = getReminders
        self.getEvents = getEvents
    }
    
    func loadData() {
        do{
            let pet = try getPet.execute()
            self.pet = pet
            self.reminders = try getReminders.execute()
            self.events = try getEvents.execute()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }    
}
