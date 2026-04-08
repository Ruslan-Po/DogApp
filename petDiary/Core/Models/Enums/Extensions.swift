import Foundation
import SwiftUI

extension Text {
    func cruinn(_ font: Cruinn, size: CGFloat) -> some View {
        self.font(.custom(font.rawValue, size: size))
    }
}
 
