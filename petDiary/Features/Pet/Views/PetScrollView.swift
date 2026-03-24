import Foundation
import SwiftUI

struct PetScrollView: View {
    let pets: [Pet]
    
    var onPetSelected: (Pet) -> Void
    var onAddNewPet: () -> Void
    
    
    var body: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(pets) { pet in
                    PetCardScrollView(pet: pet).onTapGesture {
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
