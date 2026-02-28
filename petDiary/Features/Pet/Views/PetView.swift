import SwiftUI
import SwiftData

struct PetView: View {
    @StateObject var viewModel: PetViewModel
    
    @State var name: String = ""
    @State var showEdit: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("\(name)")
            
            Button {
                removePet()
            } label: {
                Text("remove")
            }
            Button {
                showEdit = true
            } label: {
                Text("Редактировать")
            }
            
            if let pet = viewModel.pet{
                NavigationLink("Добавить" ){
                    ReminderBuilder.build(for: pet)
                }
            }
            
            List{
                ForEach(viewModel.reminders){ reminders in
                    ReminderCardView(reminder: reminders)
                        .onChange(of: reminders.doneCondition) { _, isDone in
                            if isDone {
                                viewModel.removeReminder(reminders)
                            }
                        }
                }
                
                .onDelete { indexSet in
                    for index in indexSet {
                        let reminder = viewModel.reminders[index]
                        viewModel.removeReminder(reminder)
                    }
                }
            }
        }
        .sheet(isPresented: $showEdit, onDismiss: getData) {
            EditPetBuilder.build()
        }
        .onAppear{
            getData()
            viewModel.reminders = viewModel.pet?.reminders ?? []
        }

    }
    
    func getData(){
        do{
            let currentPet = try viewModel.getPet()
            self.name = currentPet.name
        } catch {
            print("Ошибка: \(error)")
        }
    }
    
    func removePet(){
        do {
            try viewModel.removePet()
        }catch {
            print("Нету нахуй")
        }
    }
}

