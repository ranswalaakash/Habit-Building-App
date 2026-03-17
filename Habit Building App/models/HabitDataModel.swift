//
//  HabitDataModel.swift
//  Habit Harmony
//
//  Created by GEU on 03/02/26.
//


import Foundation
import UIKit

// MARK: - UIColor Extension
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


// MARK: - HabitDataModel
class HabitDataModel {
    
    static let shared = HabitDataModel()
    
    // Stored Data
    private var phases: [HabitPhase] = []
    private var habits: [HabitList] = []
    private var collaborativePhases: [CollaborativePhase] = []
    private var collaborativeActivities: [CollaborativeActivityList] = []
    
    private var habitCompletions: [HabitCompletion] = []
    
    private init() {
        loadPhases()
        loadCollaborativePhases()
        loadCollaborativeActivities()
        loadHabits()
    }
    
    // MARK: - Getters
    
    func getPhases() -> [HabitPhase] {
        return phases
    }
    
    func getHabits(for phase: HabitPhaseType) -> [HabitList] {
        return habits.filter { $0.phase == phase }
    }
    
    func getCollaborativePhases() -> [CollaborativePhase] {
        return collaborativePhases
    }
    
    func getCollaborativeActivities() -> [CollaborativeActivityList] {
        return collaborativeActivities
    }
    
    // MARK: - Habit Completion
    
    func completeHabit(_ habitId: UUID) {
        let completion = HabitCompletion(
            habitId: habitId,
            date: Date()
        )
        
        habitCompletions.append(completion)
    }
    
    func isHabitCompletedToday(_ habitId: UUID) -> Bool {
        return habitCompletions.contains {
            $0.habitId == habitId &&
            Calendar.current.isDateInToday($0.date)
        }
    }
    
    // MARK: - Phase Progress
    
    func phaseProgress(for phase: HabitPhaseType) -> Float {
        
        let phaseHabits = habits.filter { $0.phase == phase }
        
        if phaseHabits.isEmpty { return 0 }
        
        let completed = phaseHabits.filter {
            isHabitCompletedToday($0.id)
        }
        
        return Float(completed.count) / Float(phaseHabits.count)
    }
    
    // MARK: - Load Phases
    
    // MARK: - Loaders
    
    private func loadPhases() {
        phases = [
            HabitPhase(
                title: "Foundation Phase",
                subtitle: "Helps build basic daily routines.",
                icon: "cube.fill",
                color: .systemOrange,
                type: .foundational
            ),
            HabitPhase(
                title: "Growth Phase",
                subtitle: "Builds creativity and self-expression.",
                icon: "leaf.fill",
                color: .systemGreen,
                type: .growth
            ),
            HabitPhase(
                title: "Responsibility Phase",
                subtitle: "Builds life skills and independence.",
                icon: "briefcase.fill",
                color: .systemBlue,
                type: .responsibility
            ),
            HabitPhase(
                title: "Academics Phase",
                subtitle: "Improves focus and learning.",
                icon: "book.fill",
                color: .systemPurple,
                type: .academics
            )
        ]
    }
    
    private func loadCollaborativePhases() {
        collaborativePhases = [
            CollaborativePhase(
                title: "Collaborative Space",
                subtitle: "Build habits together with your child",
                iconImage: "collaborative"
            )
        ]
    }
    
    private func loadCollaborativeActivities() {
        
        collaborativeActivities = [
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Special Playtime",
                description: "A short daily play session where the child leads and the parent follows.",
                activityImage: "special_playtime",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Set the Time", detail: "Choose a quiet 10–15 minute time where you can fully focus on your child without distractions.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Follow the Child", detail: "Sit with your child and let them choose the activity. Do not give instructions or ask questions.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Describe & Imitate", detail: "Describe what your child is doing like a sports announcer and copy their actions to show their ideas matter.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Builds confidence, independence, and a strong parent-child bond while reducing behavioral issues.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Kitchen Science Lab",
                description: "Fun science experiment introducing chemistry.",
                activityImage: "science_volcano",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Prepare Materials", detail: "Place a small bottle in a tray and fill it with baking soda and food coloring.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Create the Reaction", detail: "Let the child slowly pour vinegar into the bottle and watch the bubbling reaction.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Teaches cause-and-effect and introduces acid-base reactions in a visual way.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Nature Scavenger Hunt",
                description: "Outdoor activity turning a walk into a learning adventure.",
                activityImage: "nature_hunt",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Make a Checklist", detail: "Create a simple list of items like a smooth rock, a Y-shaped stick, or a yellow flower.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Explore Together", detail: "Walk through a park or garden and help your child find each item.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Improves observation skills, environmental awareness, and physical activity.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Mealtime Math",
                description: "Using everyday meals to teach counting and measurement.",
                activityImage: "mealtime_math",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Count Items", detail: "Ask your child to count plates, spoons, or glasses needed for the family.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Estimate Volumes", detail: "Let the child guess how many spoons of water will fill a cup.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Builds early math skills, estimation, and logical thinking.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "LEGO Museum Tour",
                description: "Building play combined with storytelling.",
                activityImage: "lego_museum",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Build Creations", detail: "Let the child build anything they like using blocks or LEGO.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Museum Tour", detail: "Ask the child to explain each creation as if guiding a museum tour.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Improves language skills, confidence, and spatial reasoning.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Floating Ketchup",
                description: "Physics activity demonstrating pressure and buoyancy.",
                activityImage: "floating_ketchup",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Set Up Bottle", detail: "Fill a clear plastic bottle with water and add a ketchup packet.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Squeeze & Release", detail: "Squeeze the bottle to make the packet sink and release to make it float.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Introduces density and pressure concepts through hands-on play.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Home Writing Center",
                description: "Creative space for early writing and communication.",
                activityImage: "writing_center",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Set Up Space", detail: "Provide paper, markers, envelopes, and crayons at a small table.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Write Together", detail: "Help the child write letters, menus, or simple drawings.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Supports early literacy, creativity, and fine motor skills.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Target Practice",
                description: "A fun throwing game to improve coordination.",
                activityImage: "target_practice",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Create Targets", detail: "Cut holes in a cardboard box and assign points to each hole.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Take Turns", detail: "Throw soft balls or beanbags from different distances.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Develops hand-eye coordination and gross motor skills.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Egg Carton Caterpillar",
                description: "Creative craft using recycled materials.",
                activityImage: "egg_caterpillar",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Prepare Carton", detail: "Cut an egg carton into strips for the caterpillar body.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Decorate", detail: "Paint and decorate, then add pipe cleaners for antennae.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Improves fine motor control and encourages creativity.", isExpanded: false)
                ]
            ),
            
            CollaborativeActivityList(
                id: UUID(),
                title: "Flashlight Storytelling",
                description: "A calm storytelling game using imagination.",
                activityImage: "flashlight_story",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Dim the Room", detail: "Turn off the lights and use a flashlight to point at objects.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Create Stories", detail: "Take turns telling short stories about the object in the light.", isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps", detail: "Boosts language development, creativity, and emotional bonding.", isExpanded: false)
                ]
            )
            
        ]
    }
    // MARK: - Load Habits
    
    private func loadHabits() {
        
        habits = [
            
            // FOUNDATION
            
            HabitList(
                id: UUID(),
                title: "Brush Teeth",
                icon: "tooth",
                phase: .foundational,
                description: "Maintain daily oral hygiene",
                traits: ["Hygiene","Discipline","Health"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Make Bed",
                icon: "bed.double",
                phase: .foundational,
                description: "Build discipline by organizing your space",
                traits: ["Discipline","Responsibility","Order"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Drink Water",
                icon: "drop.fill",
                phase: .foundational,
                description: "Stay hydrated throughout the day",
                traits: ["Health","Awareness","Routine"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Wash Hands",
                icon: "hand.raised",
                phase: .foundational,
                description: "Practice cleanliness and prevent illness",
                traits: ["Cleanliness","Health","Awareness"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Sleep on Time",
                icon: "moon.fill",
                phase: .foundational,
                description: "Ensure proper rest and recovery",
                traits: ["Discipline","Energy","Focus"],
                benefits: [],
                harms: []
            ),
            
            // GROWTH
            
            HabitList(
                id: UUID(),
                title: "Daily Reading",
                icon: "book.fill",
                phase: .growth,
                description: "Develop a consistent reading habit",
                traits: ["Focus","Curiosity","Learning"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Write Journal",
                icon: "pencil",
                phase: .growth,
                description: "Express thoughts and reflect daily",
                traits: ["Reflection","Expression","Awareness"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Practice Drawing",
                icon: "paintbrush",
                phase: .growth,
                description: "Enhance creativity through drawing",
                traits: ["Creativity","Patience","Expression"],
                benefits: [],
                harms: []
            ),
            
            // RESPONSIBILITY
            
            HabitList(
                id: UUID(),
                title: "Pack School Bag",
                icon: "backpack.fill",
                phase: .responsibility,
                description: "Plan ahead for school responsibilities",
                traits: ["Responsibility","Planning","Independence"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Clean Room",
                icon: "house.fill",
                phase: .responsibility,
                description: "Maintain cleanliness and ownership",
                traits: ["Ownership","Order","Discipline"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Help Parents",
                icon: "person.2.fill",
                phase: .responsibility,
                description: "Support family members at home",
                traits: ["Empathy","Support","Gratitude"],
                benefits: [],
                harms: []
            ),
            
            // ACADEMICS
            
            HabitList(
                id: UUID(),
                title: "Solve Puzzles",
                icon: "brain.head.profile",
                phase: .academics,
                description: "Improve logical and analytical skills",
                traits: ["Logic","Problem Solving","Focus"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Learn New Words",
                icon: "text.book.closed",
                phase: .academics,
                description: "Enhance vocabulary and language skills",
                traits: ["Vocabulary","Memory","Learning"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Math Practice",
                icon: "plus.slash.minus",
                phase: .academics,
                description: "Build confidence in mathematics",
                traits: ["Accuracy","Logic","Confidence"],
                benefits: [],
                harms: []
            ),
            
            HabitList(
                id: UUID(),
                title: "Learn New Words",
                icon: "text.book.closed",
                phase: .academics,
                description: "Practice new words through repetition",
                traits: ["Vocabulary","Memory","Learning"],
                benefits: [],
                harms: []
            )
        ]
    }
}

class RewardDataModel {

    static let shared = RewardDataModel()
    private init() {}

    var rewards: [Reward] = []

    func addReward(name: String) {

        let reward = Reward(
            id: UUID(),
            name: name,
            entries: []
        )

        rewards.append(reward)
    }

    func addEntry(to rewardID: UUID, title: String, date: Date) {

        let entry = RewardEntry(
            id: UUID(),
            rewardId: rewardID,
            title: title,
            date: date
        )

        if let index = rewards.firstIndex(where: { $0.id == rewardID }) {
            rewards[index].entries.append(entry)
        }
    }

    func getEntries(for rewardID: UUID) -> [RewardEntry] {
        return rewards.first(where: { $0.id == rewardID })?.entries ?? []
    }
}


let sampleRewards: [Reward] = [
    Reward(id: UUID(), name: "Evening Ice Cream Treat with Family", entries: []),
    Reward(id: UUID(), name: "Watch a Movie Together on Weekend", entries: []),
    Reward(id: UUID(), name: "Special Pizza Night at Home", entries: []),
    Reward(id: UUID(), name: "Choose the Dinner Menu for the Day", entries: []),
    Reward(id: UUID(), name: "Extra 30 Minutes of Cartoon Time", entries: [])
]

