import Foundation
import SwiftData

@Model
final class Event {
    @Attribute(.unique) var id: UUID
    var pet: Pet?
    var category: EventCategory
    var title: String
    var date: Date
    var note: String?
    var createAt: Date
    var updateAt: Date
 
    
    init(id: UUID,
         pet: Pet? = nil,
         category: EventCategory,
         title: String,
         date: Date,
         note: String? = nil)
    {
        self.id = id
        self.pet = pet
        self.category = category
        self.title = title
        self.date = date
        self.note = note
        self.createAt = Date()
        self.updateAt = Date()
    }
    
    func update(other: Event) -> Bool {
        var isChange = false
        
        if category != other.category {
            category = other.category
            isChange = true
        }
        
        if title != other.title {
            title = other.title
            isChange = true
        }
        if date != other.date {
            date = other.date
            isChange = true
        }
        if note != other.note {
            note = other.note
            isChange = true
        }
        self.updateAt = Date()
        return isChange
    }
}
