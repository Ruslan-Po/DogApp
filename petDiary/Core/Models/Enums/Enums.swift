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
    
    var title: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        }
    }
}

enum DataManagerError: Error {
    case petNotFound
}

enum ReminderViewMode {
    case add
    case edit(Reminder)
}
