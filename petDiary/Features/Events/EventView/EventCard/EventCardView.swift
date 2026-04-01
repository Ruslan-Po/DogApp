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
                .foregroundStyle(.blue)
                //.padding(8)
            
            VStack(alignment: .leading){
                Text(event.title)
                    .font(.headline)
                
                Text(event.pet?.name ?? "")
            }
            
            Text(event.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
            
        } .padding()
           .background(Color.brandBackground)
            .cornerRadius(12)
    }
}




