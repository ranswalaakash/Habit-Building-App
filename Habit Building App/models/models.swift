//
//  phaseCollectionDataModel.swift
//  Habit Harmony
//
//  Created by GEU on 02/02/26.
//

import Foundation
import UIKit

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

struct CollaborativeActivityList {
    
    let id: UUID
    let title: String
    let description: String
    let activityImage: String
    let steps: [CollaborativeActivitySteps]
}


struct CollaborativeActivitySteps {
    let stepLabel: String     // "Step 1", "Step 2", "Benefits"
    let title: String         // Main heading
    let detail: String        // Expandable text
    var isExpanded: Bool
}

struct HabitList: Identifiable, Codable {
    
    let id: UUID
    let title: String
    let icon: String
    let phase: HabitPhaseType
    let description: String
    
    let traits: [String]
    let benefits: [String]
    let harms: [String]
}

enum HabitPhaseType: String, Codable {
    case foundational
    case growth
    case responsibility
    case academics
}

struct HabitCompletion {
    let habitId: UUID
    let date: Date
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


