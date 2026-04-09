import Foundation
import SwiftUI

enum EventCategory: String, Codable, CaseIterable {
    case health
    case activity
    case nutrition
    case grooming
    case bath
    case training
    case toilet
    case other
    
    var icon: String {
        switch self {
        case .health: return "health"
        case .activity: return "activity"
        case .nutrition: return "nutrition"
        case .grooming: return "grooming"
        case .bath: return "bath"
        case .training: return "training"
        case .toilet: return "poop"
        case .other: return "other"
        }
    }
    
    var title: String {
        switch self {
        case .health: return "category.health".localized
        case .activity: return "category.activity".localized
        case .nutrition: return "category.nutrition".localized
        case .grooming: return "category.grooming".localized
        case .bath: return "category.bath".localized
        case .training: return "category.training".localized
        case .toilet: return "category.toilet".localized
        case .other: return "category.other".localized
        }
    }
}

enum Gender: String, Codable, CaseIterable {
    case male
    case female
    var title: String {
        switch self {
        case .male: return "gender.male".localized
        case .female: return "gender.female".localized
        }
    }
}

enum RepeatInterval: String, Codable, CaseIterable {
    case daily
    case weekly
    case monthly
    
    var title: String {
        switch self {
        case .daily: return "interval.daily".localized
        case .weekly: return "interval.weekly".localized
        case .monthly: return "interval.monthly".localized
        }
    }
}

enum DataManagerError: Error {
    case petNotFound
    case profileNotFound
    
}

enum ReminderViewMode {
    case add(Pet?)
    case edit(Reminder)
}

enum AutoConvertReminder {
    case yes
    case no
}

enum EventViewMode{
    case add(Pet?)
    case edit(Event)
}

enum NavigationDirection {
    case forward
    case backward
}

enum Allergen: String, CaseIterable, Identifiable {
    case chicken
    case beef
    case pork
    case fish
    case dairy
    case eggs
    case wheat
    case corn
    case soy
    case lamb
    case dust
    case pollen
    case fleas
    case mold

    var id: String { rawValue }

    var title: String {
        switch self {
        case .chicken: return "allergen.chicken".localized
        case .beef: return "allergen.beef".localized
        case .pork: return "allergen.pork".localized
        case .fish: return "allergen.fish".localized
        case .dairy: return "allergen.dairy".localized
        case .eggs: return "allergen.eggs".localized
        case .wheat: return "allergen.wheat".localized
        case .corn: return "allergen.corn".localized
        case .soy: return "allergen.soy".localized
        case .lamb: return "allergen.lamb".localized
        case .dust: return "allergen.dust".localized
        case .pollen: return "allergen.pollen".localized
        case .fleas: return "allergen.fleas".localized
        case .mold: return "allergen.mold".localized
        }
    }

    var icon: String {
        switch self {
        case .chicken, .beef, .pork, .lamb: return "fork.knife"
        case .fish: return "fish"
        case .dairy: return "cup.and.saucer"
        case .eggs: return "oval"
        case .wheat, .corn, .soy: return "leaf"
        case .dust: return "aqi.medium"
        case .pollen: return "allergens"
        case .fleas: return "ant"
        case .mold: return "humidity"
        }
    }
}


enum Cruinn: String {
    case thin = "Cruinn-Thin"
    case light = "Cruinn-Light"
    case regular = "Cruinn"
    case medium = "Cruinn-Medium"
    case bold = "Cruinn-Bold"
    case black = "Cruinn-Black"
}



