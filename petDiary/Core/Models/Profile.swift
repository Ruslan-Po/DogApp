import Foundation
import SwiftData

@Model
final class Profile {

    var id: UUID = UUID()
    var name: String?
    var telephone: String?
    var address: String?
    var autoConvertReminders: Bool = false
    
    init(id: UUID,
         name: String? = nil,
         telephone: String? = nil,
         address: String? = nil,
         autoConvertReminders: Bool) {
        self.id = id
        self.name = name
        self.telephone = telephone
        self.address = address
        self.autoConvertReminders = autoConvertReminders
    }
    
    
    func update(other: Profile) -> Bool {
        var hasChanges: Bool = false
        if other.name != nil {
            self.name = other.name
            hasChanges = true
        }
        if other.telephone != nil {
            self.telephone = other.telephone
            hasChanges = true
        }
        if other.address != nil {
            self.address = other.address
            hasChanges = true
        }
        if autoConvertReminders != other.autoConvertReminders {
            self.autoConvertReminders = other.autoConvertReminders
            hasChanges = true
        }
        return hasChanges
    }
}

