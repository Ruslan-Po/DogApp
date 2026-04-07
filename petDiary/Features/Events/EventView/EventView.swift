import SwiftUI

struct EventView: View {
    @StateObject var viewModel: EventViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var title: String = ""
    @State var category: EventCategory = .other
    @State var note: String = ""
    @State var date: Date = Date()
    @State var portionSizeGrams: String = ""

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
            if let p = event.portionSize {
                self._portionSizeGrams = State(initialValue: String(Int(p)))
            }
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
                
                Text("Category")
                    .font(.headline)
                
                CategoryGridView(selected: $category)
                
                VStack() {
                    if pet == nil {
                        Picker("Pet", selection: $pet) {
                            Text("Choose a pet").tag(Pet?.none)
                            ForEach(viewModel.pets ?? []) { p in
                                Text(p.name).tag(p as Pet?)
                            }
                        }
                        .pickerStyle(.menu)
                    } else {
                        Text(pet!.name)
                    }
                    DatePicker("Datetime", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .padding()
                }

                if category == .nutrition {
                    TextField("Serving size (g)", text: $portionSizeGrams)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                Button ("Сохранить"){
                    let portion = Double(portionSizeGrams)

                    switch mode {
                    case .add:
                        guard let pet = self.pet else { return }
                        viewModel.addEvent(title: title,
                                           category: category,
                                           date: date,
                                           note: note,
                                           pet: pet,
                                           portionSize: portion)
                    case .edit(let event):
                        viewModel.updateEvent(event,
                                              title: title,
                                              date: date,
                                              note: note,
                                              portionSize: portion)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty)
                Spacer() 
            }.task {
                viewModel.loadPets()
            }
            .padding()
        }
    }
}



