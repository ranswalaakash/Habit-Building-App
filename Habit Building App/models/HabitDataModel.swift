//
//  HabitDataModel.swift
//  Habit Harmony
//
//  Created by GEU on 03/02/26.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

class HabitDataModel {
    
    static let shared = HabitDataModel()
    
    private var phases: [HabitPhase] = []
    private var habits: [HabitList] = []
    private var collaborativePhases: [CollaborativePhase] = []
    private var collaborativeActivities: [CollaborativeActivityList] = []
    private var habitCompletions: [HabitCompletion] = []
    private var userAddedHabits: [Habit] = []
    
    private init() {
        loadPhases()
        loadCollaborativePhases()
        loadCollaborativeActivities()
        loadHabits()
    }
    
    
    func getPhases() -> [HabitPhase] { phases }
    
    func getHabits(for phase: HabitPhaseType) -> [HabitList] {
        habits.filter { $0.phase == phase }
    }
    
    func getCollaborativePhases() -> [CollaborativePhase] { collaborativePhases }
    
    func getCollaborativeActivities() -> [CollaborativeActivityList] { collaborativeActivities }
    
    func addUserHabit(_ habit: Habit) {
        userAddedHabits.append(habit)
    }
    
    func getUserAddedHabits() -> [Habit] {
        return userAddedHabits
    }
    func getHabits(for date: Date) -> [Habit] {
        let calendar = Calendar.current
        return userAddedHabits.filter { habit in
            habit.assignedDates.contains { assignedDate in
                calendar.isDate(assignedDate, inSameDayAs: date)
            }
        }
    }
    
    func updateHabitStatus(habitId: String, status: HabitStatus) {
        guard let index = userAddedHabits.firstIndex(where: { $0.habitId == habitId }) else { return }
        userAddedHabits[index].status = status
    }
    
    func addHabit(_ habit: HabitList) {
        habits.append(habit)
    }
    
    func getActivities(for filter: String) -> [CollaborativeActivityList] {
        guard filter != "all" else { return collaborativeActivities }
        return collaborativeActivities.filter { $0.timeCategory == filter }
    }
    
    func updateHabit(_ habit: HabitList) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
    }
    
    func getActivitiesBySection() -> [(title: String, icon: String, items: [CollaborativeActivityList])] {
        return [
            ("Quick Picks",         "⚡", collaborativeActivities.filter { $0.timeCategory == "quick"  }),
            ("Learning Activities", "📚", collaborativeActivities.filter { $0.timeCategory == "medium" }),
            ("Creative Activities", "🎨", collaborativeActivities.filter { $0.timeCategory == "long"   })
        ]
    }
    
    
    func completeHabit(_ habitId: String) {
        habitCompletions.append(HabitCompletion(habitId: habitId, date: Date()))
    }

    func isHabitCompletedToday(_ habitId: String) -> Bool {
        habitCompletions.contains {
            $0.habitId == habitId && Calendar.current.isDateInToday($0.date)
        }
    }
    
    private func loadCollaborativeActivities() {
        collaborativeActivities = load("collaborative_activities")
    }

    private func loadHabits() {
        habits = load("habits")
    }
    
    private func load<T: Decodable>(_ filename: String) -> [T] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([T].self, from: data)) ?? []
    }
    
    
    func phaseProgress(for phase: HabitPhaseType) -> Float {
        let phaseHabits = habits.filter { $0.phase == phase }
        if phaseHabits.isEmpty { return 0 }
        let completed = phaseHabits.filter { isHabitCompletedToday($0.id) }
        return Float(completed.count) / Float(phaseHabits.count)
    }
    
    
    private func loadPhases() {
        phases = [
            HabitPhase(title: "Foundation Phase",     subtitle: "Helps build basic daily routines.",        icon: "cube.fill",         color: .systemOrange, type: .foundational),
            HabitPhase(title: "Growth Phase",          subtitle: "Builds creativity and self-expression.",   icon: "leaf.fill",         color: .systemGreen,  type: .growth),
            HabitPhase(title: "Responsibility Phase",  subtitle: "Builds life skills and independence.",     icon: "briefcase.fill",    color: .systemBlue,   type: .responsibility),
            HabitPhase(title: "Academics Phase",       subtitle: "Improves focus and learning.",             icon: "book.fill",         color: .systemPurple, type: .academics)
        ]
    }
    
    private func loadCollaborativePhases() {
        collaborativePhases = [
            CollaborativePhase(title: "Collaborative Space", subtitle: "Build habits together with your child", iconImage: "collaborative")
        ]
    }
    
    
}

class RewardDataModel {

    static let shared = RewardDataModel()
    private init() {}

    var rewards: [Reward] = []

    func addReward(name: String) {
        rewards.append(Reward(id: UUID(), name: name, entries: []))
    }

    func addEntry(to rewardID: UUID, title: String, date: Date) {
        let entry = RewardEntry(id: UUID(), rewardId: rewardID, title: title, date: date)
        if let index = rewards.firstIndex(where: { $0.id == rewardID }) {
            rewards[index].entries.append(entry)
        }
    }

    func getEntries(for rewardID: UUID) -> [RewardEntry] {
        rewards.first(where: { $0.id == rewardID })?.entries ?? []
    }
}

let sampleRewards: [Reward] = [
    Reward(id: UUID(), name: "Evening Ice Cream Treat with Family",  entries: []),
    Reward(id: UUID(), name: "Watch a Movie Together on Weekend",    entries: []),
    Reward(id: UUID(), name: "Special Pizza Night at Home",          entries: []),
    Reward(id: UUID(), name: "Choose the Dinner Menu for the Day",   entries: []),
    Reward(id: UUID(), name: "Extra 30 Minutes of Cartoon Time",     entries: [])
]
