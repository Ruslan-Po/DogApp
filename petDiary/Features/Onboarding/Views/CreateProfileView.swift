import SwiftUI

struct CreateProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    var onComplete: () -> Void

    @State private var name: String = ""
    @State private var telephone: String = ""
    @State private var address: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.blue)

                Text("About you")
                    .font(.title2.bold())

                Text("This info helps personalize your experience")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    TextField("Your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Phone number", text: $telephone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)

                    TextField("Address", text: $address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Button {
                    createProfile()
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    createProfile()
                } label: {
                    Text("Skip")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }

    private func createProfile() {
        let profile = viewModel.getOrCreateProfile()
        profile.name = name.isEmpty ? nil : name
        profile.telephone = telephone.isEmpty ? nil : telephone
        profile.address = address.isEmpty ? nil : address
        onComplete()
    }
}
