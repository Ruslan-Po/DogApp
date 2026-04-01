import Foundation
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        List {
            Section("Уведомления") {
                HStack {
                    Label("Уведомления о напоминаниях", systemImage: "bell.fill")
                    Spacer()
                    Toggle("", isOn: $viewModel.notificationsEnabled)
                        .labelsHidden()
                        .onChange(of: viewModel.notificationsEnabled) { _, _ in
                            Task { try? await viewModel.toggleNotifications() }
                        }
                }
            }

            Section("Автоматизация") {
                HStack {
                    Label("Авто-конвертация напоминаний", systemImage: "clock.arrow.circlepath")
                    Spacer()
                    Toggle("", isOn: $viewModel.autoConvertReminders)
                        .labelsHidden()
                        .onChange(of: viewModel.autoConvertReminders) { _, newValue in
                            viewModel.updateAutoConvert(newValue)
                        }
                }

                if viewModel.autoConvertReminders {
                    Label(
                        "Истёкшие напоминания автоматически становятся событиями",
                        systemImage: "info.circle"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Настройки")
        .onAppear { viewModel.loadProfile() }
    }
}
