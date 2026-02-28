import SwiftUI
import SwiftData

struct EditPetView: View {
    @StateObject var viewModel: EditPetViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String
    @State var breed: String
    
    
    init(viewModel: EditPetViewModel){
        _viewModel = StateObject(wrappedValue: viewModel)
        _name = State(initialValue: viewModel.pet?.name ?? "")
        _breed = State(initialValue: viewModel.pet?.breed ?? "")
    }
    
    var body: some View {
        TextField("Name", text: $name)
        TextField("Breed", text: $breed)
        Button {
            updatePet()
            dismiss()
        } label: {
            Text("Update")
        }
    }
    
    func updatePet() {
        let pet = Pet(
            name: self.name,
            breed: self.breed,
            birthDate: Date()
        )
        viewModel.updatePet(pet)
    }
}
