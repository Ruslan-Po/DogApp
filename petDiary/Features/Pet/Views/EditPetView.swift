import SwiftUI
import PhotosUI

struct EditPetView: View {
    @StateObject var viewModel: EditPetViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String
    @State var breed: String
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var avatarData: Data?
    @State var details: String
    @State var gender: Gender?
    @State var birthDate: Date
    @State var allergens: [String] = []
    @State var foodBrand: String = "FoodBrand"
    @State var vetContact: String = "VetContact"
    
    init(viewModel: EditPetViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _name = State(initialValue: viewModel.pet?.name ?? "")
        _breed = State(initialValue: viewModel.pet?.breed ?? "")
        _avatarData = State(initialValue: viewModel.pet?.avatar)
        _details = State(initialValue: viewModel.pet?.detail ?? "")
        _gender = State(initialValue: viewModel.pet?.gender)
        _allergens = State(initialValue: viewModel.pet?.allergens ?? [])
        _foodBrand = State(initialValue: viewModel.pet?.foodBrand ?? "")
        _birthDate = State(initialValue: viewModel.pet?.birthDate ?? Date())
        _vetContact = State(initialValue: viewModel.pet?.vetContact ?? "")
    }
    
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

                    TextField("Description", text: $details, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)

                    TextField("Food Brand", text: $foodBrand)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Vet Contact", text: $vetContact)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Gender", selection: $gender) {
                        Text("Unknown").tag(Gender?.none)
                        ForEach(Gender.allCases, id: \.self) { g in
                            Text(g.title).tag(Gender?.some(g))
                        }
                    }
                    .pickerStyle(.segmented)

                    AllergenPickerView(allergens: $allergens)

                    Button {
                        updatePet()
                        dismiss()
                    } label: {
                        Text("Update")
                    }
                }
                .padding()
            }
        }
    }
    
    func updatePet() {
        guard let pet = viewModel.pet else { return }
        pet.name = self.name
        pet.breed = self.breed.isEmpty ? nil : self.breed
        pet.detail = self.details.isEmpty ? nil : self.details
        pet.gender = self.gender
        pet.avatar = self.avatarData
        pet.allergens = self.allergens
        pet.foodBrand = self.foodBrand.isEmpty ? nil : self.foodBrand
        pet.vetContact = self.vetContact.isEmpty ? nil : self.vetContact
        pet.birthDate = self.birthDate
        pet.updatedAt = Date()
        viewModel.save() 
    }
}
