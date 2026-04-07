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
    @State private var interval: RepeatInterval = .daily
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
        ZStack{
            Color.brandBackgroundLight.ignoresSafeArea()
            ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                TextField("Title", text: $title)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Text("Category")
                    .font(.headline)
                
                CategoryGridView(selected: $selectedCategory)
                
                VStack(alignment: .leading, spacing: 30) {
                    Text ("For")
                    if let pet = pet {
                        Text(pet.name)
                    } else {
                        Picker("Pet", selection: $pet) {
                            Text("Choose a pet").tag(Pet?.none)
                            ForEach(viewModel.pets ?? []) { pet in
                                Text(pet.name).tag(pet as Pet?)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    DatePicker("Datetime", selection: $scheduleDate, displayedComponents: [.date, .hourAndMinute])
                        .padding()
                }
                
                Toggle("Repeat", isOn: $isRepeating)
                
                if isRepeating {
                    HStack{
                        Text("Repeat interval")
                        Picker("repeat interval", selection: $interval) {
                            ForEach(RepeatInterval.allCases, id: \.self) {
                                Text($0.rawValue.capitalized)
                                    .tag($0)
                            }
                        }
                    }
                }
                
                
                Button ("Save"){
                    
                    switch mode {
                    case .add:
                        guard let pet = self.pet else { return }
                        viewModel.addReminder(
                            title: title,
                            category: selectedCategory,
                            isRepeating: isRepeating,
                            interval: interval,
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
                            interval: interval,
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
        }
            .task {
                viewModel.loadPets()
            }
            .padding()
        }
    }
}
