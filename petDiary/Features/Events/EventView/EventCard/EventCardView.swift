import Foundation
import SwiftUI

struct EventCardView : View {
    @Bindable var event: Event
    
    var body: some View {
        HStack {
            Image(event.category.icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(.blue)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.1))
                )
            
            Text(event.title)
                .font(.headline)
            
            Text(event.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
            
        } .padding()
            .background(Color.brandBackgroundLight)
            .cornerRadius(12)
    }
}




