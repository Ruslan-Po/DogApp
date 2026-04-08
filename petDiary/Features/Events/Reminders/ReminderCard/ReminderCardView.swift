import SwiftUI

struct ReminderCardView: View {
    @Bindable var reminder: Reminder
    
    var body: some View {
        HStack(alignment: .center) {
            Toggle("TODO", isOn: $reminder.doneCondition).toggleStyle(CheckboxToggleStyle())
            Spacer()
            HStack {
                
                Image(reminder.category.icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundStyle(reminder.scheduleDate <= Date() ? Color.petzenCoral : Color.petzenTeal)
                    .padding(8)
                  
                VStack(alignment: .leading ){
                    Text(reminder.title)
                        .cruinn(.black, size: 20)
                        .font(.headline)
                    
                    Text(reminder.pet?.name ?? "")
                        .cruinn(.medium, size: 14)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(reminder.scheduleDate.formatted(.dateTime
                        .day()
                        .month(.abbreviated)
                    )).cruinn(.regular, size: 20)
                    Text(reminder.scheduleDate.formatted(.dateTime
                        .hour()
                        .minute()
                    )).cruinn(.regular, size: 20)
                }
                .font(.system(size: 20))
        
            } .padding()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.brandBackground, lineWidth: 2)
                )
        }
    }
}

