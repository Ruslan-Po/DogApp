import SwiftUI

struct TabItemView: View {
    var item: TabItem
    @Binding var selector: CoordinatorTags
    
    var isSelected: Bool {
        selector == item.tag
    }
    var body: some View {
        Button {
            selector = item.tag
        } label: {
            Image(item.image)
                .resizable()
                .frame(width: 40 , height: 40)
                .foregroundColor(isSelected ? .petzenOlive : .brandBackgroundLight)
        }
    }
}
