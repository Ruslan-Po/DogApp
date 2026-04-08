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
        case .health: return "Health"
        case .activity: return "Activity"
        case .nutrition: return "Nutrition"
        case .grooming: return "Grooming"
        case .bath: return "Bath"
        case .training: return "Training"
        case .toilet: return "Toilet"
        case .other: return "Other"
        }
    }
}

enum Gender: String, Codable, CaseIterable {
    case male
    case female
    var title: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}

enum RepeatInterval: String, Codable, CaseIterable {
    case daily
    case weekly
    case monthly
    
    var title: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly : return "Monthly"
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
        case .chicken: return "Chicken"
        case .beef: return "Beef"
        case .pork: return "Pork"
        case .fish: return "Fish"
        case .dairy: return "Dairy"
        case .eggs: return "Eggs"
        case .wheat: return "Wheat"
        case .corn: return "Corn"
        case .soy: return "Soy"
        case .lamb: return "Lamb"
        case .dust: return "Dust"
        case .pollen: return "Pollen"
        case .fleas: return "Fleas"
        case .mold: return "Mold"
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



