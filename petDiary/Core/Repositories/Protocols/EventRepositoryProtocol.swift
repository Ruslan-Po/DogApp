import Foundation

protocol EventRepositoryProtocol {
    func save(for pet: Pet,_ event: Event)
    func delete(_ event: Event)
    func getAll() throws -> [Event]
    func update(_ event: Event,_ newEvent: Event)
}
