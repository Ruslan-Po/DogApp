import Foundation
import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case en
    case ru

    var id: String { rawValue }

    var title: String {
        switch self {
        case .en: return "English"
        case .ru: return "Русский"
        }
    }

    var icon: String {
        switch self {
        case .en: return "🇬🇧"
        case .ru: return "🇷🇺"
        }
    }
}

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    private static let key = "app_language"

    @Published var current: AppLanguage {
        didSet {
            UserDefaults.standard.set(current.rawValue, forKey: Self.key)
            Bundle.setLanguage(current.rawValue)
        }
    }

    private init() {
        let saved = UserDefaults.standard.string(forKey: Self.key)
            ?? Locale.current.language.languageCode?.identifier
            ?? "en"
        let lang = AppLanguage(rawValue: saved) ?? .en
        self.current = lang
        Bundle.setLanguage(lang.rawValue)
    }
}
