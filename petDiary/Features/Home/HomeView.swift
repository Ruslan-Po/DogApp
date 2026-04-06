import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    @State var showAdd: Bool = false
    @State var showEdit: Bool = false
    @State var editingEvent: Event? = nil
    @State var editingReminder: Reminder? = nil
    @State private var remindersExpanded = true
    @State private var eventsExpanded = true

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

                List {
                    Section {
                        if remindersExpanded {
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
                                    .onTapGesture {
                                        print("tapped")
                                    }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    viewModel.removeReminder(viewModel.filteredReminders[index])
                                }
                            }
                        }
                    } header: {
                        CollapsibleSectionHeader(title: "Reminders", isExpanded: $remindersExpanded)
                    }

                    Section {
                        if eventsExpanded {
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
                    } header: {
                        CollapsibleSectionHeader(title: "Events", isExpanded: $eventsExpanded)
                    }
                }
                .animation(.default, value: remindersExpanded)
                .animation(.default, value: eventsExpanded)
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

struct CollapsibleSectionHeader: View {
    let title: String
    @Binding var isExpanded: Bool

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 0 : -90))
                    .foregroundStyle(.secondary)
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
