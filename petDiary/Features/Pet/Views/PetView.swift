import SwiftUI

struct PetView: View {
    @StateObject var viewModel: PetViewModel
    
    @State var name: String = ""
    @State var showEdit: Bool = false
    @State var showAdd: Bool = false
    
    var body: some View {

        VStack(alignment: .center, spacing: 20) {
            if let pets = viewModel.pets{
                PetScrollView(pets: pets,
                              onPetSelected: {pet in viewModel.selectPet(pet)},
                              onAddNewPet: {showAdd = true})
            }
            if let pet = viewModel.selectedPet{
                Text("\(pet.name)")
            }
           
            
            Button {
                removePet()
            } label: {
                Text("remove pet")
            }
            Button {
                showEdit = true
            } label: {
                Text("Edit Pet")
            }
            
            if let pet = viewModel.selectedPet{
                NavigationLink("Add Reminder" ){
                    ReminderBuilder.build(for: pet)
                }
            }
            
            NavigationLink("Add Event") {
                EventBuilder.build()
            }
            
            Text("Reminders")
            
            List{
                ForEach(viewModel.reminders){ reminders in
                    ReminderCardView(reminder: reminders)
                        .onChange(of: reminders.doneCondition) { _, isDone in
                            if isDone {
                                viewModel.convertToEvent(reminders)
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
            
            Text("Events")
            List{
                ForEach(viewModel.events) {events in
                    EventCardView(event: events)
                }.onDelete { indexSet in
                    for index in indexSet {
                        let event = viewModel.events[index]
                        viewModel.removeEvent(event)
                    }
                }
            }
        }
        .onAppear{
            getData()
            viewModel.reminders = viewModel.selectedPet?.reminders ?? []
        }
        .sheet(isPresented: $showEdit, onDismiss: getData) {
            if let pet = viewModel.selectedPet {
                EditPetBuilder.build(for: pet)
            }
        }
        .sheet(
            isPresented: $showAdd, onDismiss: getData){AddPetViewBuilder.build()}
    }
    
    func getData(){
        do{
            let currentPet = try viewModel.getPet()
            self.name = currentPet.first?.name ?? ""
            try viewModel.loadEvents()
        } catch {
            print("Ошибка: \(error)")
        }
    }
    
    func removePet(){
        do {
            if let pet = viewModel.selectedPet{
                try viewModel.removePet(pet: pet)
            }
    
        }catch {
            print("Нету нахуй")
        }
    }
}

