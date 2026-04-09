import Foundation
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var languageManager: LanguageManager
    @FocusState private var focusedField: ProfileField?

    enum ProfileField {
        case name, telephone, address
    }

    var body: some View {
        List {
            Section("profile.section".localized) {
                HStack {
                    Label {
                        Text("profile.name".localized).cruinn(.medium, size: 14)
                    } icon: {
                        Image(systemName: "person")
                    }
                    Spacer()
                    TextField("profile.yourName".localized, text: $viewModel.name)
                        .font(.custom(Cruinn.regular.rawValue, size: 14))
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .name)
                        .onSubmit { saveAndNext(.telephone) }
                }

                HStack {
                    Label {
                        Text("profile.phone".localized).cruinn(.medium, size: 14)
                    } icon: {
                        Image(systemName: "phone")
                    }
                    Spacer()
                    TextField("profile.phoneNumber".localized, text: $viewModel.telephone)
                        .font(.custom(Cruinn.regular.rawValue, size: 14))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.phonePad)
                        .focused($focusedField, equals: .telephone)
                }

                HStack {
                    Label {
                        Text("profile.address".localized).cruinn(.medium, size: 14)
                    } icon: {
                        Image(systemName: "mappin.and.ellipse")
                    }
                    Spacer()
                    TextField("profile.address".localized, text: $viewModel.address)
                        .font(.custom(Cruinn.regular.rawValue, size: 14))
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .address)
                        .onSubmit { saveAndNext(nil) }
                }
            }

            Section("profile.notifications".localized) {
                HStack {
                    Label {
                        Text("profile.reminders".localized).cruinn(.medium, size: 14)
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

            Section("profile.automation".localized) {
                HStack {
                    Label {
                        Text("profile.autoConvert".localized).cruinn(.medium, size: 14)
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
                        Text("profile.autoConvertDescription".localized)
                            .cruinn(.light, size: 12)
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                    .foregroundStyle(.secondary)
                }
            }

            Section {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        languageManager.current = lang
                    } label: {
                        HStack {
                            Text(lang.icon)
                            Text(lang.title)
                                .cruinn(.medium, size: 14)
                                .foregroundStyle(.primary)
                            Spacer()
                            if languageManager.current == lang {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.petzenTeal)
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    Image(systemName: "globe")
                    Text("profile.language".localized)
                        .cruinn(.medium, size: 14)
                }
            }
        }
        .navigationTitle("profile.title".localized)
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
