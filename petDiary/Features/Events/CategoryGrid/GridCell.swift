import Foundation
import SwiftUI

struct GridCell: View {
    let category: EventCategory
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack {
                Image(category.icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(isSelected ? Color.petzenCoral : Color.petzenOlive)
                Text(category.title)
                    .cruinn(.medium, size: 12)
                    .lineLimit(1)
                
            }

        }
     
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
    
}
