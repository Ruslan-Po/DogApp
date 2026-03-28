import SwiftUI

struct PetCardScrollView: View {
    let pet: Pet
    let isSelected: Bool
    var body: some View {
    
        HStack {
            Text(pet.name)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
        }.padding()
            .background(isSelected ? Color.brandAccent : Color.brandBackgroundLight)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.brandAccent : Color.clear, lineWidth: 2)
            )
    }
}
