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
                    Picker("common.filter".localized, selection: $viewModel.filterPetId) {
                        Text("common.all".localized)
                            .cruinn(.bold, size: 18)
                            .tag(UUID?.none)
                        ForEach(pets) { pet in
                            Text(pet.name)
                                .cruinn(.regular, size:14)
                                .tag(UUID?
                                .some(pet.id))
                                
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }

                HStack {
                    if let pets = viewModel.pet, !pets.isEmpty {
                        NavigationLink {
                            ReminderBuilder.build(for: viewModel.filterPet)
                        } label: {
                            Text("home.addReminder".localized)
                                .cruinn(.bold, size: 18)
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color.petzenOlive)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            EventBuilder.build(for: viewModel.filterPet)
                        } label: {
                            Text("home.addEvent".localized)
                                .cruinn(.bold, size: 18)
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color.petzenOlive)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }

                List {
                    Section {
                        if remindersExpanded {
                            ForEach(viewModel.filteredReminders) { reminder in
                                ReminderCardView(reminder: reminder)
                                    .listRowBackground(Color.brandBackgroundLight)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                    .onChange(of: reminder.doneCondition) { _, isDone in
                                        if isDone {
                                            viewModel.convertAndComplete(reminder)
                                        }
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.removeReminder(reminder)
                                        } label: {
                                            Label("common.remove".localized, systemImage: "trash")
                                        }
                                        Button {
                                            editingReminder = reminder
                                        } label: {
                                            Label("common.edit".localized, systemImage: "pencil")
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
                        CollapsibleSectionHeader(title: "home.reminders".localized, isExpanded: $remindersExpanded)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
                            .listRowBackground(Color.brandBackgroundLight)
                    }

                    Section {
                        if eventsExpanded {
                            ForEach(viewModel.filteredEvents) { event in
                                EventCardView(event: event)
                                    .listRowBackground(Color.brandBackgroundLight)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.removeEvent(event)
                                        } label: {
                                            Label("common.remove".localized, systemImage: "trash")
                                        }

                                        Button {
                                            editingEvent = event
                                        } label: {
                                            Label("common.edit".localized, systemImage: "pencil")
                                        }
                                        .tint(.orange)
                                    }
                            }
                        }
                    } header: {
                        CollapsibleSectionHeader(title: "home.events".localized, isExpanded: $eventsExpanded)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
                            .listRowBackground(Color.brandBackgroundLight)
                    }
                }
                .animation(.default, value: remindersExpanded)
                .animation(.default, value: eventsExpanded)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .onAppear {
                viewModel.loadData()
                UISegmentedControl.appearance().setTitleTextAttributes(
                    [.font: UIFont(name: Cruinn.bold.rawValue, size: 14) ?? UIFont.boldSystemFont(ofSize: 14)],
                    for: .normal
                )
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
        .onAppear {
            viewModel.loadData()
        }
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
                    .cruinn(.bold, size: 18)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 0 : -90))
                    .foregroundStyle(.secondary)
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.brandBackgroundLight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}



