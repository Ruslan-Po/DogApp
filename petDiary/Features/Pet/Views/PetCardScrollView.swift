import SwiftUI

struct PetCardScrollView: View {
    let pet: Pet
    let isSelected: Bool
    var body: some View {

        HStack {
            Text(pet.name)
                .cruinn(.bold, size: 20)
                .foregroundStyle(isSelected ? Color.primary : Color.secondary)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.brandBackground : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.clear : Color.brandBackground.opacity(0.5), lineWidth: 1)
        )
    }
}
