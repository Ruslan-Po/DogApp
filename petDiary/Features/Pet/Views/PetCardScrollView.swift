import SwiftUI

struct PetCardScrollView: View {
    let pet: Pet
    
    var body: some View {
        HStack {
            Text(pet.name)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
        }
    }
}
