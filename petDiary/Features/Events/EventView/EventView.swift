import SwiftUI

struct EventView: View {
    @StateObject var viewModel: EventViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var title: String = ""
    @State var category: EventCategory = .other
    @State var note: String = ""
    @State var date: Date = Date()
    
    @State private var pet: Pet? = nil
    
    let mode: EventViewMode
    
    init(viewModel: EventViewModel, mode: EventViewMode = .add(nil)) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.mode = mode
        
        if case .edit(let event) = mode {
            self._title = State(initialValue: event.title)
            self._category = State(initialValue: event.category)
            self._note = State(initialValue: event.note ?? " ")
            self._date = State(initialValue: event.date)
        }
    }
    
    var body: some View {
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                
                TextField("Название", text: $title)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Text("Категория")
                    .font(.headline)
                
                CategoryGridView(selected: $category)
                
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
                    DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .padding()
                }
                
                
                Button ("Сохранить"){
                    switch mode {
                    case .add:
                        guard let pet = self.pet else { return }
                        viewModel.addEvent(title: title,
                                           category: category,
                                           date: date,
                                           note: note,
                                           pet: pet)
                    case .edit(let event):
                        viewModel.updateEvent(event,
                                              title: title,
                                              date: date,
                                              note: note)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty)
            }.task {
                viewModel.loadPets()
            }
            .padding()
        }
    }
}



