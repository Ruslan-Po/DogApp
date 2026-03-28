import SwiftUI

struct HomeView: View {
    @StateObject  var viewModel: HomeViewModel
    
    @State var showAdd: Bool = false
    @State var showEdit: Bool = false
    
    
    var body: some View {
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
            VStack {
                
                if let pets = viewModel.pet, pets.count > 0 {
                    Picker("Фильтр", selection: $viewModel.filterPetId) {
                        Text("Все").tag(UUID?.none)
                        ForEach(pets) { pet in
                            Text(pet.name).tag(UUID?.some(pet.id))
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                HStack{
                    if let pets = viewModel.pet, !pets.isEmpty {
                        
                        NavigationLink("Add Reminder") {
                            ReminderBuilder.build(for: viewModel.filterPet)
                        }
                        
                        NavigationLink("Add Event") {
                            EventBuilder.build(for: viewModel.filterPet)
                        }
                    }
                }
                
                Text("Reminders")
                
                List{
                    ForEach(viewModel.filteredReminders){ reminders in
                        ReminderCardView(reminder: reminders)
                            .onChange(of: reminders.doneCondition) { _, isDone in
                                if isDone {
                                    if let pet = reminders.pet {
                                        viewModel.convertToEvent(for: pet, reminders)
                                    }
                                    viewModel.removeReminder(reminders)
                                    viewModel.loadData()
                                }
                            }
                    }
                    
                    .onDelete { indexSet in
                        for index in indexSet {
                            let reminder = viewModel.filteredReminders[index]
                            viewModel.removeReminder(reminder)
                        }
                    }
                }
                
                Text("Events")
                List {
                    ForEach(viewModel.filteredEvents) { event in
                        EventCardView(event: event)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let event = viewModel.filteredEvents[index]
                            viewModel.removeEvent(event)
                        }
                    }
                }
                .animation(.default, value: viewModel.events)
            }
            
            
            .onAppear{
                viewModel.loadData()
                viewModel.reminders = viewModel.selectedPet?.reminders ?? []
            }
            .sheet(isPresented: $showEdit, onDismiss: viewModel.loadData) {
                if let pet = viewModel.selectedPet {
                    EditPetBuilder.build(for: pet)
                }
            }
            
        }.onAppear{viewModel.loadData()}
    }
}


