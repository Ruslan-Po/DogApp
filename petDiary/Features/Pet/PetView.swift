import SwiftUI
import SwiftData

struct PetView: View {
    @Query private var pets: [Pet]
    @State private var showingEditSheet = false
    
    var body: some View {
        if let pet = pets.first {
            ScrollView {
                VStack(spacing: 24) {
                    if let avatarData = pet.avatar, let uiImage = UIImage(data: avatarData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80 , height: 80)
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .overlay {
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.gray)
                            }
                    }
                    
                    VStack(spacing: 8) {
                        Text(pet.name)
                            .font(.title.bold())
                        
                        if let breed = pet.breed {
                            Text(breed)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text("\(pet.age) years old")
                            .font(.callout)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.brandPrimary.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    
                    VStack(spacing: 12) {
                        
                        if let gender = pet.gender {
                            HStack {
                                Text("Gender")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(gender.rawValue)
                                    .fontWeight(.medium)
                            }
                            Divider()
                        }
                        
                        HStack {
                            Text("Birth Date")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(pet.birthDate.formatted(date: .long, time: .omitted))
                                .fontWeight(.medium)
                        }
                        
                        if let weight = pet.weight {
                            Divider()
                            HStack {
                                Text("Weight")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(weight, specifier: "%.1f") kg")
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                    Button {
                        showingEditSheet = true
                    } label: {
                        Text("Edit Profile")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brandBackground)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle("Pet Profile")
            .sheet(isPresented: $showingEditSheet) {
                EditPetView(pet: pet)
            }
        } else {
            ContentUnavailableView("No Pet", systemImage: "pawprint")
        }
    }
}
