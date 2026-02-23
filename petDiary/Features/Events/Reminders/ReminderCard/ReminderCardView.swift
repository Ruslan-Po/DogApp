import SwiftUI

struct ReminderCardView: View {
     let reminder: Reminder
    
    var body: some View {
        HStack {
            Image(reminder.category.icon)
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
                        
            Text(reminder.title)
                .font(.headline)
        } .padding()
            .background(Color.brandBackgroundLight)
            .cornerRadius(12)
    }
}

