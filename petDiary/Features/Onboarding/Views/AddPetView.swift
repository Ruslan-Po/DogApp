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
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
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
                    .buttonStyle(.plain)
                    .onChange(of: selectedPhoto) { _, newValue in
                        Task {
                            if let item = newValue {
                                avatarData = try? await item.loadTransferable(type: Data.self)
                            }
                        }
                    }
                    
                    TextField("pet.name".localized, text: $name)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    DatePicker("pet.birthDate".localized, selection: $birthDate, displayedComponents: .date)

                    TextField("pet.breed".localized, text: $breed)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("pet.gender".localized, selection: $gender) {
                        Text("common.unknown".localized).tag(Gender?.none)
                        ForEach(Gender.allCases, id: \.self) { g in
                            Text(g.title).tag(Gender?.some(g))
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    TextField("pet.details".localized, text: $details, axis: .vertical)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)

                    TextField("pet.foodBrand".localized, text: $foodBrand)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("pet.vetContact".localized, text: $vetContact)
                        .font(.custom(Cruinn.regular.rawValue, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    AllergenPickerView(allergens: $allergens)
                    
                    Button {
                        addPet()
                    } label: {
                        Text("pet.addPet".localized)
                            .cruinn(.bold, size: 18)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(Color.petzenOlive)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
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
