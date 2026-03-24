import SwiftUI


struct AddPetView: View {
    @StateObject var viewModel: AddPetViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = "Dobby"
    @State var birthDate: Date = Date(timeIntervalSince1970: 1_000_000)
    @State var breed: String = "Shih Tzu"


    var body: some View {
        VStack(alignment: .center) {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date).datePickerStyle(.wheel)
            
            TextField("Breed", text: $breed)
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
            birthDate: self.birthDate
        )

        viewModel.save(pet: pet)
        dismiss()
    }
}
