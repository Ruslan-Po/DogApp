import SwiftUI

struct ReminderCardView: View {
    @Bindable var reminder: Reminder
    
    var body: some View {
        HStack {
            Toggle("TODO", isOn: $reminder.doneCondition).toggleStyle(CheckboxToggleStyle())
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
            
            Text(reminder.pet?.name ?? "")
            
            Text(reminder.scheduleDate.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
            
        } .padding()
            .background(Color.brandBackgroundLight)
            .cornerRadius(12)
    }
}

