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
                    .cruinn(.bold, size: 24)

                Text("This info helps personalize your experience")
                    .cruinn(.regular, size: 14)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    TextField("Your name", text: $name)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Phone number", text: $telephone)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)

                    TextField("Address", text: $address)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Button {
                    createProfile()
                } label: {
                    Text("Continue")
                        .cruinn(.bold, size: 18)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.petzenOlive)
                        .cornerRadius(10)
                }

                Button {
                    createProfile()
                } label: {
                    Text("Skip")
                        .cruinn(.regular, size: 14)
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
