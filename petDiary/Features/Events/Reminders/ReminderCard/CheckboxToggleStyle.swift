import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: configuration.isOn ? "circle.fill": "circle")
                .foregroundStyle(configuration.isOn ? .blue : .gray)
                .font(.system(size: 24)) 
            
        }
        .buttonStyle(.plain)
    }
}


