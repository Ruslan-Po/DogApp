import SwiftUI
import SwiftData
import PhotosUI

struct AddPetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let isOnboarding: Bool
    @State private var name = ""
    @State private var breed = ""
    @State private var gender: Gender? = nil
    @State private var birthDate = Date()
    @State private var weightText = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var avatarData: Data?
    
    var body: some View {
           NavigationStack {
               VStack (alignment: .center ){
                   PhotosPicker(selection: $selectedPhoto, matching: .images) {
                       HStack {
                           Spacer()
                           if let avatarData, let uiImage = UIImage(data: avatarData) {
                               Image(uiImage: uiImage)
                                   .resizable()
                                   .scaledToFill()
                                   .frame(width: 150, height: 150)
                                   .clipShape(Circle())
                           } else {
                               Circle()
                                   .fill(Color.cyan.opacity(0.3))
                                   .frame(width: 150, height: 150)
                                   .overlay {
                                       VStack(spacing: 8) {
                                           Image(systemName: "camera.fill")
                                               .font(.largeTitle)
                                               .foregroundStyle(Color.brandBackground)
                                           Text("Add Photo")
                                               .font(.caption)
                                               .foregroundStyle(.secondary)
                                       }
                                   }
                           }
                           Spacer()
                       }
                       .padding(.vertical, 8)
                   }
               }
               Form {
                              Section {
                                  TextField("Name", text: $name)
                                      .autocorrectionDisabled()
                                  
                                  TextField("Breed (optional)", text: $breed)
                                      .autocorrectionDisabled()
                              } header: {
                                  Text("Basic Information")
                              }
                              
                              Section {
                                  Picker("Gender", selection: $gender) {
                                      Text("Not specified").tag(nil as Gender?)
                                      ForEach(Gender.allCases, id: \.self) { genderOption in
                                          Text(genderOption.rawValue).tag(genderOption as Gender?)
                                      }
                                  }
                                  
                                  DatePicker("Birth Date", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                                  
                                  HStack {
                                      TextField("Weight (optional)", text: $weightText)
                                          .keyboardType(.decimalPad)
                                      Text("kg").foregroundStyle(.secondary)
                                  }
                              } header: {
                                  Text("Details")
                              }
                              
                              Section {
                                  Button {
                                      savePet()
                                  } label: {
                                      Text("Save")
                                          .font(.headline)
                                          .frame(maxWidth: .infinity)
                                  }
                                  .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                              }
                          }
                          .navigationTitle("Add Pet")
                          .navigationBarTitleDisplayMode(.large)
                          .onChange(of: selectedPhoto) { _, newValue in
                              Task {
                                  if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                      avatarData = data
                                  }
                              }
                          }
                      }
                  }
    
    private func savePet() {
            let pet = Pet(
                name: name.trimmingCharacters(in: .whitespaces),
                breed: breed.isEmpty ? nil : breed.trimmingCharacters(in: .whitespaces),
                birthDate: birthDate,
                avatar: avatarData,
                weight: Double(weightText.replacingOccurrences(of: ",", with: ".")),
                gender: gender
            )
            modelContext.insert(pet)
        }
    
}
