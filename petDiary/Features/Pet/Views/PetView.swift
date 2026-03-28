import SwiftUI
import PhotosUI

struct PetView: View {
    @StateObject var viewModel: PetViewModel
    
    @State var name: String = ""
    @State var showEdit: Bool = false
    @State var showAdd: Bool = false
    @State var description: String?
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var avatarData: Data?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                
                if let pets = viewModel.pets{
                    PetScrollView(pets: pets,
                                  selectedPet: viewModel.selectedPet,
                                  onPetSelected: {pet in viewModel.selectPet(pet)},
                                  onAddNewPet: {showAdd = true})
                }
                
                
                HStack (alignment: .center , spacing: 20 ){
                    
                    PhotosPicker (selection: $selectedPhoto , matching: .images ){
                        if let data = avatarData, let uiImage = UIImage(data: data){
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
                    }.onChange(of: selectedPhoto) { _, newValue in
                        Task {
                            avatarData = try? await newValue?.loadTransferable(type: Data.self)
                            viewModel.updatePet { $0.avatar = avatarData }
                            
                        }
                    }
                    
                }
                Button {
                    removePet()
                } label: {
                    Text("remove pet")
                }
                Button {
                    showEdit = true
                } label: {
                    Text("Edit Pet")
                }
                
                Text(description ?? "Description")
                
                
            }
            .onAppear{
                getData()
                avatarData = viewModel.selectedPet?.avatar
                description = viewModel.selectedPet?.detail
                
            }
            .onChange(of: viewModel.selectedPet) { _, newPet in
                avatarData = newPet?.avatar
                description = newPet?.detail
            }
            .sheet(isPresented: $showEdit, onDismiss: {
                getData()
                description = viewModel.selectedPet?.detail
                avatarData = viewModel.selectedPet?.avatar
            }) {
                if let pet = viewModel.selectedPet {
                    EditPetBuilder.build(for: pet)
                }
            }
            .sheet(
                isPresented: $showAdd, onDismiss: getData){AddPetViewBuilder.build()}
        }.padding(20)
    }
    
    func getData(){
        do{
            let currentPet = try viewModel.getPet()
            self.name = currentPet.first?.name ?? ""
        } catch {
            print("Ошибка: \(error)")
        }
    }
    
    func removePet(){
        do {
            if let pet = viewModel.selectedPet{
                try viewModel.removePet(pet: pet)
            }
            
        }catch {
            print("Нету нахуй")
        }
    }
}

