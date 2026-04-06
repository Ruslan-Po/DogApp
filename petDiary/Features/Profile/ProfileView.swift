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
                    Label("Name", systemImage: "person")
                    Spacer()
                    TextField("Your name", text: $viewModel.name)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .name)
                        .onSubmit { saveAndNext(.telephone) }
                }

                HStack {
                    Label("Phone", systemImage: "phone")
                    Spacer()
                    TextField("Phone number", text: $viewModel.telephone)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.phonePad)
                        .focused($focusedField, equals: .telephone)
                }

                HStack {
                    Label("Address", systemImage: "mappin.and.ellipse")
                    Spacer()
                    TextField("Address", text: $viewModel.address)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .address)
                        .onSubmit { saveAndNext(nil) }
                }
            }

            Section("Notifications") {
                HStack {
                    Label("Reminders", systemImage: "bell.fill")
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
                    Label("Auto-convert reminders", systemImage: "clock.arrow.circlepath")
                    Spacer()
                    Toggle("", isOn: $viewModel.autoConvertReminders)
                        .labelsHidden()
                        .onChange(of: viewModel.autoConvertReminders) { _, newValue in
                            viewModel.updateAutoConvert(newValue)
                        }
                }

                if viewModel.autoConvertReminders {
                    Label(
                        "Expired reminders automatically become events",
                        systemImage: "info.circle"
                    )
                    .font(.caption)
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
