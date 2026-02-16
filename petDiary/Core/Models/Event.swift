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
}
