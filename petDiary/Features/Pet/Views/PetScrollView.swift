import Foundation
import SwiftUI

struct PetScrollView: View {
    
    let pets: [Pet]
    let selectedPet: Pet?
    var onPetSelected: (Pet) -> Void
    var onAddNewPet: () -> Void
    
    
    var body: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(pets) { pet in
                    PetCardScrollView(pet: pet,isSelected: pet.id == selectedPet?.id).onTapGesture {
                        onPetSelected(pet)
                    }
                }
                Button(action: onAddNewPet) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
