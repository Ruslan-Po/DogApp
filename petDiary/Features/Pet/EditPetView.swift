import SwiftUI
import PhotosUI
import SwiftData

struct EditPetView: View {
    @Environment(\.dismiss) private var dismiss
    
    let pet: Pet
    
    @State private var name = ""
    @State private var breed = ""
    @State private var gender: Gender? = nil
    @State private var birthDate = Date()
    @State private var weightText = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var avatarData: Data?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
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
                                        Text("Change Photo")
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
                
                // 🆕 Кнопка Delete
                Section {
                    Button(role: .destructive) {
                        deletePet()
                    } label: {
                        Text("Delete Pet")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Section {
                    Button {
                        savePet()
                    } label: {
                        Text("Save Changes")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Edit Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        avatarData = data
                    }
                }
            }
        }
    }
    
    init(pet: Pet) {
        self.pet = pet
        _name = State(initialValue: pet.name)
        _breed = State(initialValue: pet.breed ?? "")
        _gender = State(initialValue: pet.gender)
        _birthDate = State(initialValue: pet.birthDate)
        _weightText = State(initialValue: pet.weight.map { "\($0)" } ?? "")
        _avatarData = State(initialValue: pet.avatar)
    }
    
    private func savePet() {
        pet.name = name.trimmingCharacters(in: .whitespaces)
        pet.breed = breed.isEmpty ? nil : breed.trimmingCharacters(in: .whitespaces)
        pet.gender = gender
        pet.birthDate = birthDate
        pet.weight = Double(weightText.replacingOccurrences(of: ",", with: "."))
        pet.avatar = avatarData
        pet.updatedAt = Date()
        
        dismiss()
    }
    
    // 🆕 Функция удаления
    private func deletePet() {
        let context = pet.modelContext
        context?.delete(pet)
        dismiss()
    }
}
