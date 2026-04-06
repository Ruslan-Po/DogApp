import SwiftUI

struct PetCardScrollView: View {
    let pet: Pet
    let isSelected: Bool
    var body: some View {
        
        HStack{
            Text(pet.name)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
        }.padding(.vertical ,10 )
         .padding(.horizontal, 20)
            .background(isSelected ? Color.brandBackground : Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.brandBackground, lineWidth: 2)
            )
    }
}
