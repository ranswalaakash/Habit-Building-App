//
//  phaseCollectionDataModel.swift
//  Habit Harmony
//
//  Created by GEU on 02/02/26.
//

import Foundation
import UIKit

//new comment in all clones
struct HabitPhase {
    let title: String
    let subtitle: String
    let icon: String
    let color: UIColor
    let type: HabitPhaseType
}

struct CollaborativePhase{
    let title: String
    let subtitle: String
    let iconImage: String
}

struct CollaborativeActivityList: Identifiable, Codable {
    
    let id: UUID
    let title: String
    let description: String
    let activityImage: String
    
    let durationMinutes: Int
    let preferredAge: Int
    let materialsLabel: String
    let needsMaterials: Bool
    
    let steps: [CollaborativeActivitySteps]

    var timeCategory: String {
        switch durationMinutes {
        case ..<15: return "quick"
        case 15..<30: return "medium"
        default: return "long"
        }
    }
    
    
    var timeLabel: String {
        return "\(durationMinutes) min"
    }
}


struct CollaborativeActivitySteps: Codable  {
    let stepLabel: String
    let title: String
    let detail: String
    let imageName: String   
    var isExpanded: Bool
}

struct HabitList: Identifiable, Codable {
    
    let id: String
    var title: String
    var icon: String
    var phase: HabitPhaseType
    var description: String
    
    var traits: [String]
    var benefits: [String]
    var harms: [String]
}

enum HabitPhaseType: String, Codable {
    case foundational
    case growth
    case responsibility
    case academics
}

struct HabitCompletion {
    let habitId: String
    let date: Date
}

enum HabitStatus {
    case notDone
    case approved
    case pendingApproval
    case rejected
}

struct Habit {
    let habitId: String
    var title: String
    var status: HabitStatus
    var assignedDates: [Date]
}

struct ChildHabitProgress {
    
    let childId: UUID
    var completions: [HabitCompletion]
    
}

struct Reward {
    var id: UUID
    var name: String
    var entries: [RewardEntry]

    var redeemCount: Int {
        return entries.count
    }
}

struct RewardEntry {
    var id: UUID
    var rewardId: UUID
    var title: String
    var date: Date
}


