import Foundation
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @FocusState private var focusedField: ProfileField?

    enum ProfileField {
        case name, telephone, address
    }

    var body: some View {
        List {
            Section("Profile") {
                HStack {
                    Label {
                        Text("Name").cruinn(.medium, size: 14)
                    } icon: {
                        Image(systemName: "person")
                    }
                    Spacer()
                    TextField("Your name", text: $viewModel.name)
                        .font(.custom(Cruinn.regular.rawValue, size: 14))
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .name)
                        .onSubmit { saveAndNext(.telephone) }
                }

                HStack {
                    Label {
                        Text("Phone").cruinn(.medium, size: 14)
                    } icon: {
                        Image(systemName: "phone")
                    }
                    Spacer()
                    TextField("Phone number", text: $viewModel.telephone)
                        .font(.custom(Cruinn.regular.rawValue, size: 14))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.phonePad)
                        .focused($focusedField, equals: .telephone)
                }

                HStack {
                    Label {
                        Text("Address").cruinn(.medium, size: 14)
                    } icon: {
                        Image(systemName: "mappin.and.ellipse")
                    }
                    Spacer()
                    TextField("Address", text: $viewModel.address)
                        .font(.custom(Cruinn.regular.rawValue, size: 14))
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .address)
                        .onSubmit { saveAndNext(nil) }
                }
            }

            Section("Notifications") {
                HStack {
                    Label {
                        Text("Reminders").cruinn(.medium, size: 14)
                    } icon: {
                        Image(systemName: "bell.fill")
                    }
                    Spacer()
                    Toggle("", isOn: $viewModel.notificationsEnabled)
                        .labelsHidden()
                        .onChange(of: viewModel.notificationsEnabled) { _, _ in
                            Task { try? await viewModel.toggleNotifications() }
                        }
                }
            }

            Section("Automation") {
                HStack {
                    Label {
                        Text("Auto-convert reminders").cruinn(.medium, size: 14)
                    } icon: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    Spacer()
                    Toggle("", isOn: $viewModel.autoConvertReminders)
                        .labelsHidden()
                        .onChange(of: viewModel.autoConvertReminders) { _, newValue in
                            viewModel.updateAutoConvert(newValue)
                        }
                }

                if viewModel.autoConvertReminders {
                    Label {
                        Text("Expired reminders automatically become events")
                            .cruinn(.light, size: 12)
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear { viewModel.loadProfile() }
        .onChange(of: focusedField) { _, _ in
            viewModel.saveField()
        }
    }

    private func saveAndNext(_ next: ProfileField?) {
        viewModel.saveField()
        focusedField = next
    }
}
