import SwiftUI

struct CategoryGridView: View {
    @Binding var selected: EventCategory
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(EventCategory.allCases,id: \.self) {category in
                GridCell(category: category, isSelected: selected == category)
                    .onTapGesture {
                        selected = category
                    }
            }
        }
    }
}
