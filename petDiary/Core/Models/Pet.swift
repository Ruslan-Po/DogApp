import Foundation
import SwiftData

@Model
final class Pet: Hashable, Identifiable{
    var id: UUID = UUID()
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
    
    init(
         name: String,
         breed: String? = nil,
         birthDate: Date,
         avatar: Data? = nil,
         weight: Double? = nil,
         gender: Gender? = nil)
    {
        self.name = name
        self.id = UUID() 
        self.breed = breed
        self.birthDate = birthDate
        self.avatar = avatar
        self.weight = weight
        self.gender = gender
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var age: Int {
        Calendar.current.dateComponents([.year, .month], from: birthDate ,to: Date()).year ?? 0
    }
    
    func update(other: Pet) -> Bool {
        var hasChanges: Bool = false
        
        if name != other.name {
            name = other.name
            hasChanges = true
        }
        if breed != other.breed {
            breed = other.breed
            hasChanges = true
        }
        if avatar != other.avatar {
            avatar = other.avatar
            hasChanges = true
        }
        if birthDate != other.birthDate {
            birthDate = other.birthDate
            hasChanges = true
        }
        if weight != other.weight {
            weight = other.weight
            hasChanges = true
        }
        if gender != other.gender {
            gender = other.gender  
            hasChanges = true
        }
        
        self.updatedAt = Date()
        return hasChanges
    }
}
