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

                Text("onboarding.aboutYou".localized)
                    .cruinn(.bold, size: 24)

                Text("onboarding.aboutYouDescription".localized)
                    .cruinn(.regular, size: 14)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    TextField("profile.yourName".localized, text: $name)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("profile.phoneNumber".localized, text: $telephone)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)

                    TextField("profile.address".localized, text: $address)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Button {
                    createProfile()
                } label: {
                    Text("common.continue".localized)
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
                    Text("common.skip".localized)
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
