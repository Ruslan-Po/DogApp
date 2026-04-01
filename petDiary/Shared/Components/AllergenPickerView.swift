import SwiftUI

struct AllergenPickerView: View {
    @Binding var allergens: [String]
    @State private var newAllergen: String = ""
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("Allergens")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if !allergens.isEmpty {
                        Text("\(allergens.count)")
                            .font(.caption2)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if !allergens.isEmpty {
                AllergenTagsView(allergens: allergens, onRemove: { allergen in
                    allergens.removeAll { $0 == allergen }
                })
            }

            if isExpanded {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                    ForEach(Allergen.allCases) { allergen in
                        let isSelected = allergens.contains(allergen.title)
                        Button {
                            if isSelected {
                                allergens.removeAll { $0 == allergen.title }
                            } else {
                                allergens.append(allergen.title)
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: allergen.icon)
                                    .font(.caption)
                                Text(allergen.title)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(isSelected ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                            .foregroundStyle(isSelected ? .red : .primary)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(isSelected ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                HStack {
                    TextField("Custom allergen...", text: $newAllergen)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit { addCustomAllergen() }
                    Button(action: addCustomAllergen) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                    .disabled(newAllergen.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func addCustomAllergen() {
        let trimmed = newAllergen.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !allergens.contains(trimmed) else { return }
        allergens.append(trimmed)
        newAllergen = ""
    }
}

struct AllergenTagsView: View {
    let allergens: [String]
    var onRemove: ((String) -> Void)?

    var body: some View {
        FlowLayout(spacing: 6) {
            ForEach(allergens, id: \.self) { allergen in
                HStack(spacing: 4) {
                    if let known = Allergen(rawValue: allergen.lowercased()) {
                        Image(systemName: known.icon)
                            .font(.caption2)
                    }
                    Text(allergen)
                        .font(.caption)
                    if let onRemove {
                        Button {
                            onRemove(allergen)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 8, weight: .bold))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.red.opacity(0.15))
                .foregroundStyle(.red)
                .clipShape(Capsule())
            }
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (positions, CGSize(width: maxX, height: y + rowHeight))
    }
}
