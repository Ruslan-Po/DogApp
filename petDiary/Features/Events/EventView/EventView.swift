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
        
        if case .add(let pet) = mode {
              self._pet = State(initialValue: pet)
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
                    if pet == nil {
                        Picker("Питомец", selection: $pet) {
                            Text("Выбери питомца").tag(Pet?.none)
                            ForEach(viewModel.pets ?? []) { p in
                                Text(p.name).tag(p as Pet?)
                            }
                        }
                        .pickerStyle(.menu)
                    } else {
                        Text(pet!.name)
                    }
                    DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .padding()
                }
                
                
                Button ("Сохранить"){
                    switch mode {
                    case .add:
                        print("mode add works")
                        guard let pet = self.pet else { return }
                        viewModel.addEvent(title: title,
                                           category: category,
                                           date: date,
                                           note: note,
                                           pet: pet)
                    case .edit(let event):
                        print("mode add works")
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



