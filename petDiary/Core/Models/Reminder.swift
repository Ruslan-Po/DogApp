import Foundation
import SwiftData


@Model
final class Reminder {
    @Attribute(.unique) var id: UUID
    var pet: Pet?
    var title: String
    var category: EventCategory
    var scheduleDate: Date
    var isRepeating: Bool
    var repeatInterval: RepeatInterval?
    var isEnable: Bool
    var createdAt: Date
    var updatedAt: Date
    
    
    init(id: UUID,
         pet: Pet? = nil,
         title: String,
         category: EventCategory,
         scheduleDate: Date,
         isRepeating: Bool,
         repeatInterval: RepeatInterval? = nil,
         isEnable: Bool)
    {
        self.id = id
        self.pet = pet
        self.title = title
        self.category = category
        self.scheduleDate = scheduleDate
        self.isRepeating = isRepeating
        self.repeatInterval = repeatInterval
        self.isEnable = isEnable
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
 
}
