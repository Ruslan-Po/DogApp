import Foundation

struct TabItem: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    var tag: CoordinatorTags
}
