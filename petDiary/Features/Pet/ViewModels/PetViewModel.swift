import Foundation
import Combine
import SwiftData

final class PetViewModel: ObservableObject {
    private var loadPet: GetPetUseCaseProtocol
    private var remove: RemovePetUseCaseProtocol
    private var saveReminder: SaveReminderUseCaseProtocol
    private var deleteReminder: RemoveReminderUseCaseProtocol
    private var saveEvent: SaveEventUseCaseProtocol
    private var removeEvent: RemoveEventUseCaseProtocol
    private var convertReminder: ConvertReminderToEventUseCaseProtocol
    private var getEvents: GetEventsUseCaseProtocol
    private var updatePet: UpdatePetUseCaseProtocol

    @Published var pets: [Pet]?
    @Published var selectedPet: Pet?
    @Published var reminders: [Reminder] = []
    @Published var events: [Event] = []

    init(getPet: GetPetUseCaseProtocol,
         remove: RemovePetUseCaseProtocol,
         saveReminder: SaveReminderUseCaseProtocol,
         deleteReminder: RemoveReminderUseCaseProtocol,
         convertReminder: ConvertReminderToEventUseCaseProtocol,
         saveEvent: SaveEventUseCaseProtocol,
         removeEvent: RemoveEventUseCaseProtocol,
         getEvents: GetEventsUseCaseProtocol,
         updatePet: UpdatePetUseCaseProtocol) {
        self.loadPet = getPet
        self.remove = remove
        self.saveReminder = saveReminder
        self.deleteReminder = deleteReminder
        self.convertReminder = convertReminder
        self.saveEvent = saveEvent
        self.removeEvent = removeEvent
        self.getEvents = getEvents
        self.updatePet = updatePet
    }

    func removePet(pet: Pet) throws {
        remove.execute(pet)
        _ = try loadPets()
    }

    
    @discardableResult
    func loadPets() throws -> [Pet] {
        let result = try loadPet.execute()
        self.pets = result

        if let current = selectedPet, let updated = result.first(where: { $0.id == current.id }) {
            self.selectedPet = updated
        } else {
            self.selectedPet = result.first
        }
        self.reminders = selectedPet?.reminders ?? []
        return result
    }


    func loadPetsAndSelect(_ petID: UUID) throws {
        let result = try loadPet.execute()
        self.pets = result
        if let newPet = result.first(where: { $0.id == petID }) {
            self.selectedPet = newPet
        } else {
            self.selectedPet = result.first
        }
        self.reminders = selectedPet?.reminders ?? []
    }

    func selectPet(_ pet: Pet) {
        self.selectedPet = pet
        self.reminders = pet.reminders
    }

    func updatePet(_ update: (Pet) -> Void) {
        guard let pet = selectedPet else { return }
        update(pet)
        updatePet.execute(pet: pet)
    }
}
