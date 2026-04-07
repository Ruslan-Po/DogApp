import Foundation
import SwiftData

@Model
final class Pet: Hashable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var breed: String?
    var birthDate: Date
    var avatar: Data?
    var weight: Double?
    var gender: Gender?
    var createdAt: Date?
    var updatedAt: Date?
    var detail: String?
    var allergensRaw: String = ""
    var foodBrand: String?
    var vetContact: String?

    var allergens: [String] {
        get { allergensRaw.isEmpty ? [] : allergensRaw.components(separatedBy: "|||") }
        set { allergensRaw = newValue.joined(separator: "|||") }
    }

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
        gender: Gender? = nil,
        detail: String? = nil,
        allergens: [String] = [],
        foodBrand: String? = nil,
        vetContact: String? = nil
    ) {
        self.name = name
        self.id = UUID()
        self.breed = breed
        self.birthDate = birthDate
        self.avatar = avatar
        self.weight = weight
        self.gender = gender
        self.createdAt = Date()
        self.updatedAt = Date()
        self.detail = detail
        self.allergensRaw = allergens.joined(separator: "|||")
        self.foodBrand = foodBrand
        self.vetContact = vetContact
    }

    var age: Int {
        Calendar.current.dateComponents([.year, .month], from: birthDate, to: Date()).year  ?? 0
    }
    
    var ageFormatted: String {
        let components = Calendar.current.dateComponents([.year, .month], from: birthDate, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0
        
        if years == 0 { return "\(months) m." }
        if months == 0 { return "\(years) y." }
        return "\(years) y. \(months) mon."
    }

    func update(other: Pet) -> Bool {
        var hasChanges = false

        if name != other.name { name = other.name; hasChanges = true }
        if breed != other.breed { breed = other.breed; hasChanges = true }
        if avatar != other.avatar { avatar = other.avatar; hasChanges = true }
        if birthDate != other.birthDate { birthDate = other.birthDate; hasChanges = true }
        if weight != other.weight { weight = other.weight; hasChanges = true }
        if gender != other.gender { gender = other.gender; hasChanges = true }
        if detail != other.detail { detail = other.detail; hasChanges = true }
        if allergens != other.allergens { allergens = other.allergens; hasChanges = true }
        if foodBrand != other.foodBrand { foodBrand = other.foodBrand; hasChanges = true }
        if vetContact != other.vetContact { vetContact = other.vetContact; hasChanges = true }

        self.updatedAt = Date()
        return hasChanges
    }
}
