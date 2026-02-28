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
    var doneTime: Date
    var doneCondition: Bool
    
    
    init(id: UUID,
         pet: Pet? = nil,
         title: String,
         category: EventCategory,
         scheduleDate: Date,
         isRepeating: Bool,
         repeatInterval: RepeatInterval? = nil,
         isEnable: Bool,
         doneTime: Date,
        doneCondition: Bool = false)
    {
        self.id = id
        self.pet = pet
        self.title = title
        self.category = category
        self.scheduleDate = Date()
        self.isRepeating = isRepeating
        self.repeatInterval = repeatInterval
        self.isEnable = isEnable
        self.createdAt = Date()
        self.updatedAt = Date()
        self.doneTime = doneTime
        self.doneCondition = doneCondition
    }
    
    func update(other: Reminder) -> Bool {
        var hasChange: Bool = false
        
        if title != other.title {
            title = other.title
            hasChange = true
        }
        
        if category != other.category {
            category = other.category
            hasChange = true
        }
        
        if scheduleDate != other.scheduleDate {
            scheduleDate = other.scheduleDate
            hasChange = true
        }
        
        if isRepeating != other.isRepeating {
            isRepeating = other.isRepeating
            hasChange = true
        }
        
        if repeatInterval != other.repeatInterval {
            repeatInterval = other.repeatInterval
            hasChange = true
        }
        
        return hasChange
    }
}
