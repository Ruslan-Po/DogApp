import Foundation
import SwiftData

struct PetViewBuilder {
    static func build() -> PetView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = PetRepository(dataManager: dataManager)
        let reminderRepository = ReminderRepository(dataManager: dataManager)
        let eventRepository = EventRepository(dataManager: dataManager)
        let get = GetPetUseCase(repository: repository)
        let remove = RemovePetUseCase(repository: repository)
        let removeReminder = RemoveReminderUseCase(repository: reminderRepository)
        let saveReminder = SaveReminderUseCase(repository: reminderRepository)
        let convertReminder = ConvertReminderToEventUseCase(repository: eventRepository)
        let saveEvent = SaveEventUseCase(repository: eventRepository)
        let removeEvent = RemoveEventUseCase(repository: eventRepository)
        let getEvent = GetEventsUseCase(repository: eventRepository)
        let updatePet = UpdatePetUseCase(repository: repository)
        
        let viewModel = PetViewModel(getPet: get,
                                     remove: remove,
                                     saveReminder: saveReminder,
                                     deleteReminder: removeReminder,
                                     convertReminder: convertReminder,
                                     saveEvent: saveEvent,
                                     removeEvent: removeEvent ,
                                     getEvents: getEvent, updatePet: updatePet)
        
        return PetView(viewModel: viewModel)
    }
}
