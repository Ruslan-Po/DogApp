import SwiftUI
import PhotosUI

struct PetView: View {
    @StateObject var viewModel: PetViewModel

    @State private var showEdit: Bool = false
    @State private var showAdd: Bool = false

    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {

                if let pets = viewModel.pets {
                    PetScrollView(pets: pets,
                                  selectedPet: viewModel.selectedPet,
                                  onPetSelected: { pet in viewModel.selectPet(pet) },
                                  onAddNewPet: { showAdd = true })
                }

                HStack(alignment: .center, spacing: 20) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let data = viewModel.selectedPet?.avatar, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "pawprint.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.gray)
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newValue in
                        Task {
                            let data = try? await newValue?.loadTransferable(type: Data.self)
                            viewModel.updatePet { $0.avatar = data }
                        }
                    }
                }

                Button { removePet() } label: { Text("remove pet") }
                Button { showEdit = true } label: { Text("Edit Pet") }

                HStack {
                    Text("Gender").foregroundStyle(.secondary)
                    Text(viewModel.selectedPet?.gender?.title ?? "Unknown")
                }

                Text(viewModel.selectedPet?.detail ?? "Description")
                Text(viewModel.selectedPet?.foodBrand ?? "foodBrand")
                Text(viewModel.selectedPet?.vetContact ?? "vetContact")

                if let allergens = viewModel.selectedPet?.allergens, !allergens.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Allergens")
                            .font(.headline)
                        AllergenTagsView(allergens: allergens)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear {
               try? viewModel.loadPets()
            }
            .sheet(isPresented: $showEdit, onDismiss: {
                try? viewModel.loadPets()
            }) {
                if let pet = viewModel.selectedPet {
                    EditPetBuilder.build(for: pet)
                }
            }
            .sheet(isPresented: $showAdd) {
                AddPetViewBuilder.build { newPetID in
                    try? viewModel.loadPetsAndSelect(newPetID)
                }
            
            }
        }
        .padding(20)
    }

    func removePet() {
        do {
            if let pet = viewModel.selectedPet {
                try viewModel.removePet(pet: pet)
            }
        } catch {
            print("Ошибка удаления: \(error)")
        }
    }
}
