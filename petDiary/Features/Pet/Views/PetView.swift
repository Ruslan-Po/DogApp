import SwiftUI
import PhotosUI

struct PetView: View {
    @StateObject var viewModel: PetViewModel

    @State private var showEdit: Bool = false
    @State private var showAdd: Bool = false

    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 0) {
            // Fixed header
            VStack(spacing: 12) {
                if let pets = viewModel.pets {
                    PetScrollView(pets: pets,
                                  selectedPet: viewModel.selectedPet,
                                  onPetSelected: { pet in viewModel.selectPet(pet) },
                                  onAddNewPet: { showAdd = true })
                }

                HStack(spacing: 12) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let data = viewModel.selectedPet?.avatar, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "pawprint.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.gray)
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newValue in
                        Task {
                            let data = try? await newValue?.loadTransferable(type: Data.self)
                            viewModel.updatePet { $0.avatar = data }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.selectedPet?.name ?? "")
                            .font(.title3.bold())
                        HStack(spacing: 8) {
                            Text(viewModel.selectedPet?.breed ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(viewModel.selectedPet?.gender?.title ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    Button { showEdit = true } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 8)

            Divider()

            // Scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    if let detail = viewModel.selectedPet?.detail, !detail.isEmpty {
                        Text(detail)
                            .font(.subheadline)
                    }

                    if let food = viewModel.selectedPet?.foodBrand, !food.isEmpty {
                        HStack {
                            Text("Food").foregroundStyle(.secondary).font(.caption)
                            Text(food).font(.subheadline)
                        }
                    }

                    if let vet = viewModel.selectedPet?.vetContact, !vet.isEmpty {
                        HStack {
                            Text("Vet").foregroundStyle(.secondary).font(.caption)
                            Text(vet).font(.subheadline)
                        }
                    }

                    if let allergens = viewModel.selectedPet?.allergens, !allergens.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Allergens")
                                .font(.headline)
                            AllergenTagsView(allergens: allergens)
                        }
                    }

                    if let pet = viewModel.selectedPet {
                        PetStatsView(events: pet.events)
                    }

                    Button(role: .destructive) { removePet() } label: {
                        Text("Remove pet")
                            .font(.subheadline)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .onAppear {
           _ = try? viewModel.loadPets()
        }
        .sheet(isPresented: $showEdit, onDismiss: {
           _ = try? viewModel.loadPets()
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
