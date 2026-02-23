import SwiftUI

struct ReminderView: View {
    @StateObject var viewModel: ReminderViewModel
    
    @State private var title: String = ""
    @State private var selectedCategory: EventCategory = .other
    @State private var isRepeating: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            TextField("Название", text: $title)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            Text("Категория")
                .font(.headline)
            
            CategoryGridView(selected: $selectedCategory)
            
            Toggle("Повторять", isOn: $isRepeating)
            
            Button("Добавить") {
                viewModel.addReminder(
                    title: title,
                    category: selectedCategory,
                    isRepeating: isRepeating
                )
            }
            .buttonStyle(.borderedProminent)
            .disabled(title.isEmpty)
        }
        .padding()
    }
}
