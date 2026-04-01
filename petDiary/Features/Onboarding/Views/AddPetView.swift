import SwiftUI
import PhotosUI

struct AddPetView: View {
    @StateObject var viewModel: AddPetViewModel
    @Environment(\.dismiss) private var dismiss

    var onSave: (UUID) -> Void

    @State private var name: String = ""
    @State private var birthDate: Date = Date()
    @State private var breed: String = ""
    @State private var details: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var avatarData: Data?
    @State private var gender: Gender?
    @State private var foodBrand: String = ""
    @State private var vetContact: String = ""
    @State private var allergens: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    if let data = avatarData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "pawprint.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.gray)
                    }
                }
                .onChange(of: selectedPhoto) { _, newValue in
                    Task {
                        if let item = newValue {
                            avatarData = try? await item.loadTransferable(type: Data.self)
                        }
                    }
                }

                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)

                TextField("Breed", text: $breed)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Gender", selection: $gender) {
                    Text("Unknown").tag(Gender?.none)
                    ForEach(Gender.allCases, id: \.self) { g in
                        Text(g.title).tag(Gender?.some(g))
                    }
                }
                .pickerStyle(.segmented)

                TextField("Details", text: $details, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)

                TextField("Food brand", text: $foodBrand)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Vet contact", text: $vetContact)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                AllergenPickerView(allergens: $allergens)

                Button {
                    addPet()
                } label: {
                    Text("Add Pet")
                }
            }
            .padding()
        }
    }

    private func addPet() {
        let pet = Pet(
            name: name,
            breed: breed.isEmpty ? nil : breed,
            birthDate: birthDate,
            avatar: avatarData,
            gender: gender,
            detail: details.isEmpty ? nil : details,
            allergens: allergens,
            foodBrand: foodBrand.isEmpty ? nil : foodBrand,
            vetContact: vetContact.isEmpty ? nil : vetContact
        )
        viewModel.save(pet: pet)
        onSave(pet.id)
        dismiss()
    }

}
