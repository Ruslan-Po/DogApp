import SwiftUI

struct HomeView: View {
    @StateObject  var viewModel: HomeViewModel
    
    @State var showAdd: Bool = false
    @State var showEdit: Bool = false
    @State var editingEvent: Event? = nil
    @State var editingReminder: Reminder? = nil
    
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

                    HStack {
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

                    List {
                        ForEach(viewModel.filteredReminders) { reminder in
                            ReminderCardView(reminder: reminder)
                                .listRowBackground(Color.brandBackgroundLight)
                                .listRowSeparator(.hidden)
                                .onChange(of: reminder.doneCondition) { _, isDone in
                                    if isDone {
                                        if let pet = reminder.pet {
                                            viewModel.convertToEvent(for: pet, reminder)
                                        }
                                        viewModel.completeReminder(reminder)
                                        viewModel.loadData()
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.removeReminder(reminder)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }

                                    Button {
                                        editingReminder = reminder
                                    } label: {
                                        Label("Изменить", systemImage: "pencil")
                                    }
                                    .tint(.orange)
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.removeReminder(viewModel.filteredReminders[index])
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)

                    Text("Events")

                    List {
                        ForEach(viewModel.filteredEvents) { event in
                            EventCardView(event: event)
                                .listRowBackground(Color.brandBackgroundLight)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.removeEvent(event)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }

                                    Button {
                                        editingEvent = event
                                    } label: {
                                        Label("Изменить", systemImage: "pencil")
                                    }
                                    .tint(.orange)
                                }
                        }
                    }
                    .animation(.default, value: viewModel.events)
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                .onAppear {
                    viewModel.loadData()
                }
                .sheet(item: $editingEvent, onDismiss: viewModel.loadData) { event in
                    EventBuilder.buildEdit(with: event)
                }
                .sheet(item: $editingReminder, onDismiss: viewModel.loadData) { reminder in
                    if let pet = reminder.pet {
                        ReminderBuilder.buildEdit(for: reminder, pet: pet)
                    }
                }
                .sheet(isPresented: $showEdit, onDismiss: viewModel.loadData) {
                    if let pet = viewModel.selectedPet {
                        EditPetBuilder.build(for: pet)
                    }
                }
            }
            .onAppear { viewModel.loadData() }
        }
    }
