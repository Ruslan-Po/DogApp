import Foundation
import SwiftData

@Model
final class Pet {
    @Attribute(.unique) var id: UUID
    var name: String
    var breed: String?
    var birthDate: Date
    var avatar: Data?
    var weight: Double?
    var gender: Gender?
    var createdAt: Date?
    var updatedAt: Date?
    
    
    @Relationship(deleteRule: .cascade, minimumModelCount: 0)
    var events: [Event] = []
    
    @Relationship(deleteRule: .cascade, minimumModelCount: 0)
    var reminders: [Reminder] = []
    
    init(id: UUID,
         name: String,
         breed: String? = nil,
         birthDate: Date,
         avatar: Data? = nil,
         weight: Double? = nil,
         gender: Gender? = nil)
    {
        self.id = id
        self.name = name
        self.breed = breed
        self.birthDate = birthDate
        self.avatar = avatar
        self.weight = weight
        self.gender = gender
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate ,to: Date()).year ?? 0
    }
}
