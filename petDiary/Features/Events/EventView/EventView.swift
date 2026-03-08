import SwiftUI

struct EventView: View {
    @StateObject var viewModel: EventViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var title: String = ""
    @State var category: EventCategory = .other
    @State var note: String = ""
    @State var date: Date = Date()
    
    let mode: EventViewMode
    
    init(viewModel: EventViewModel, mode: EventViewMode = .add) {
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
                
                DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .padding()
                
                
                Button ("Сохранить"){
                    switch mode {
                    case .add:
                        viewModel.addEvent(title: title,
                                           category: category,
                                           date: date,
                                           note: note)
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
            }
            .padding()
        }
        }
    }



