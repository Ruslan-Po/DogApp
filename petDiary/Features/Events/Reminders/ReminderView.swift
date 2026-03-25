import SwiftUI
struct ReminderView: View {
    @StateObject var viewModel: ReminderViewModel
    @Environment(\.dismiss) private var dismiss
    
    let mode: ReminderViewMode
    
    @State private var title: String = ""
    @State private var selectedCategory: EventCategory = .other
    @State private var isRepeating: Bool = false
    @State private var scheduleDate: Date = Date()
    @State private var isDone: Bool = false
    @State private var doneTime: Date = Date()
    
    @State private var pet: Pet? = nil
    
    init(viewModel: ReminderViewModel,
         mode: ReminderViewMode = .add(nil)) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.mode = mode
        
        if case .add(let pet) = mode {
            self._pet = State(initialValue: pet)
        }
        
        if case .edit(let reminder) = mode {
            self._title = State(initialValue: reminder.title)
            self._selectedCategory = State(initialValue: reminder.category)
            self._isRepeating = State(initialValue: reminder.isRepeating)
            self._scheduleDate = State(initialValue: reminder.scheduleDate)
            self._isDone = State(initialValue: reminder.doneCondition)
            self._doneTime = State(initialValue: reminder.doneTime)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                TextField("Название", text: $title)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Text("Категория")
                    .font(.headline)
                
                CategoryGridView(selected: $selectedCategory)
                
                VStack() {
                    if let pet = pet {
                        Text(pet.name)
                    } else {
                        Picker("Питомец", selection: $pet) {
                            // Text("Выберите питомца").tag(nil as Pet?)
                            ForEach(viewModel.pets ?? []) { pet in
                                Text(pet.name).tag(pet as Pet?)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    DatePicker("Дата и время", selection: $scheduleDate, displayedComponents: [.date, .hourAndMinute])
                        .padding()
                }
                
                
                Toggle("Повторять", isOn: $isRepeating)
                
                Button ("Сохранить"){
                    
                    switch mode {
                    case .add:
                        guard let pet = self.pet else { return }
                        viewModel.addReminder(
                            title: title,
                            category: selectedCategory,
                            isRepeating: isRepeating,
                            scheduleDate: scheduleDate,
                            doneTime: doneTime,
                            isDone: isDone,
                            pet: pet
                        )
                    case .edit(let reminder):
                        viewModel.updateReminder(
                            reminder,
                            title: title,
                            category: selectedCategory,
                            isRepeating: isRepeating,
                            scheduleDate: scheduleDate,
                            doneTime: doneTime,
                            isDone: isDone
                        )
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty)
            }
            .task {
                viewModel.loadPets()
            }
            .padding()
        }
    }
}
