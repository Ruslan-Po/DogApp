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
    
    init(viewModel: EditPetViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _name = State(initialValue: viewModel.pet?.name ?? "")
        _breed = State(initialValue: viewModel.pet?.breed ?? "")
        _avatarData = State(initialValue: viewModel.pet?.avatar)
        _details = State(initialValue: viewModel.pet?.detail ?? "")
    }
    
    var body: some View {
        VStack {
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
            TextField("Breed", text: $breed)
            TextField("Description", text: $details)
            
            Button {
                updatePet()
                dismiss()
            } label: {
                Text("Update")
            }
        }
    }
    
    func updatePet() {
        let pet = Pet(
            name: self.name,
            breed: self.breed,
            birthDate: viewModel.pet?.birthDate ?? Date(),
            avatar: avatarData,
            detail: self.details
        )
        viewModel.updatePet(pet)
    }
}
