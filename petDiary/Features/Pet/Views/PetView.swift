import SwiftUI
import PhotosUI

struct PetView: View {
    @StateObject var viewModel: PetViewModel
    
    @State private var showEdit: Bool = false
    @State private var showAdd: Bool = false
    
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        ZStack{
            Color.brandBackgroundLight.ignoresSafeArea()
            VStack(spacing: 0) {
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
                        .buttonStyle(.plain)
                        .onChange(of: selectedPhoto) { _, newValue in
                            Task {
                                let data = try? await newValue?.loadTransferable(type: Data.self)
                                viewModel.updatePet { $0.avatar = data }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {

                            VStack(alignment: .leading, spacing: 8) {
                                Text(viewModel.selectedPet?.breed ?? "")
                                    .cruinn(.regular, size: 14)
                                    .foregroundStyle(.secondary)
                                Text(viewModel.selectedPet?.gender?.title ?? "")
                                    .cruinn(.regular, size: 14)
                                    .foregroundStyle(.secondary)
                                if let age = viewModel.selectedPet?.ageFormatted {
                                    Text(age)
                                        .cruinn(.regular, size: 14)
                                        .foregroundStyle(.secondary)
                                }
                                
                            }
                        }
                        
                        Spacer()
                        
                        Button { showEdit = true } label: {
                            Image(systemName: "highlighter")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.brandSuccess)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 8)
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        if let detail = viewModel.selectedPet?.detail, !detail.isEmpty {
                            Text(detail)
                                .cruinn(.regular, size: 14)
                        }

                        if let food = viewModel.selectedPet?.foodBrand, !food.isEmpty {
                            HStack {
                                Text("pet.food".localized)
                                    .cruinn(.light, size: 12)
                                    .foregroundStyle(.secondary)
                                Text(food)
                                    .cruinn(.medium, size: 14)
                            }
                        }

                        if let vet = viewModel.selectedPet?.vetContact, !vet.isEmpty {
                            HStack {
                                Text("pet.vet".localized)
                                    .cruinn(.light, size: 12)
                                    .foregroundStyle(.secondary)
                                Text(vet)
                                    .cruinn(.medium, size: 14)
                            }
                        }

                        if let allergens = viewModel.selectedPet?.allergens, !allergens.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("pet.allergens".localized)
                                    .cruinn(.bold, size: 18)
                                AllergenTagsView(allergens: allergens)
                            }
                        }
                        
                        if let pet = viewModel.selectedPet {
                            PetStatsView(events: pet.events)
                        }
                        
                        Button(role: .destructive) { removePet() } label: {
                            Text("pet.removePet".localized)
                                .cruinn(.medium, size: 14)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
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
