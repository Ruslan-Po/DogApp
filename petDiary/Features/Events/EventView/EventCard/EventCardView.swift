import Foundation
import SwiftUI

struct EventCardView : View {
    var event: Event
    
    var body: some View {
        HStack {
            Image(event.category.icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.petzenTeal)
 

            
            VStack(alignment: .leading){
                Text(event.title)
                    .cruinn(.black, size: 20)
                
                Text(event.pet?.name ?? "")
                    .cruinn(.medium, size: 14)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text(event.date.formatted(.dateTime
                    .day()
                    .month(.abbreviated)
                )).cruinn(.regular, size: 20)
                Text(event.date.formatted(.dateTime
                    .hour()
                    .minute()
                )).cruinn(.regular, size: 20)
            }
            
        } .padding(.all, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.brandBackground, lineWidth: 2)
            )
            
    }
}




