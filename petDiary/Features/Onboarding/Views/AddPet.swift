import SwiftUI
import PhotosUI

struct AddPetView: View {
    @StateObject var viewModel: AddPetViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = "Dobby"
    @State var birthDate: Date = Date(timeIntervalSince1970: 1_000_000)
    @State var breed: String = "Breed"
    @State var details: String = "Details"
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var avatarData: Data?

    var body: some View {
        VStack(alignment: .center) {
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
                .datePickerStyle(.wheel)
            TextField("Breed", text: $breed)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $details)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button {
                addPet()
            } label: {
                Text("Add Pet")
            }
        }
    }
    
    func addPet() {
        let pet = Pet(
            name: self.name,
            breed: self.breed,
            birthDate: self.birthDate,
            avatar: avatarData,
            detail: self.details
        )
        viewModel.save(pet: pet)
        dismiss()
    }
}
