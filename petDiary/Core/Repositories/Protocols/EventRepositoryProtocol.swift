import Foundation

protocol EventRepositoryProtocol {
    func save(_ event: Event, for pet: Pet)
    func delete(event: Event, for pet: Pet)
    func getAll(for pet: Pet) throws -> [Event]
    func update(_ event: Event,_ newEvent: Event)
}
