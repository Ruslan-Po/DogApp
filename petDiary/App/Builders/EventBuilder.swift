import Foundation
import SwiftData

struct EventBuilder {
    static func buildModel() -> EventViewModel {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = EventRepository(dataManager: dataManager)
        let save = SaveEventUseCase(repository: repository)
        let update = UpdateEventUseCase(repository: repository)
        //let delete = DeleteEventUseCase(repository: repository)
        
        return EventViewModel(saveEvent: save, updateEvent: update)
        
    }
    
    static func build() -> EventView {
        let view = EventView(viewModel: buildModel(), mode: .add)
        return view
    }
    
    static func buildEdit(with event: Event) -> EventView {
        let view = EventView(viewModel: buildModel(), mode: .edit(event))
        return view
    }
}
