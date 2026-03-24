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

    func getActivities(for filter: String) -> [CollaborativeActivityList] {
        guard filter != "all" else { return collaborativeActivities }
        return collaborativeActivities.filter { $0.timeCategory == filter }
    }

    func getActivitiesBySection() -> [(title: String, icon: String, items: [CollaborativeActivityList])] {
        return [
            ("Quick Picks",         "⚡", collaborativeActivities.filter { $0.timeCategory == "quick"  }),
            ("Learning Activities", "📚", collaborativeActivities.filter { $0.timeCategory == "medium" }),
            ("Creative Activities", "🎨", collaborativeActivities.filter { $0.timeCategory == "long"   })
        ]
    }


    func completeHabit(_ habitId: UUID) {
        habitCompletions.append(HabitCompletion(habitId: habitId, date: Date()))
    }

    func isHabitCompletedToday(_ habitId: UUID) -> Bool {
        habitCompletions.contains {
            $0.habitId == habitId && Calendar.current.isDateInToday($0.date)
        }
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


    private func loadCollaborativeActivities() {

        collaborativeActivities = [

            // ── QUICK (under 15 min)

            CollaborativeActivityList(
                id: UUID(),
                title: "Special Playtime",
                description: "A short daily play session where the child leads and the parent follows.",
                activityImage: "special_playtime",
                durationMinutes: 10,
                ageRange: "3–6 yrs",
                materialsLabel: "None needed",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Set the Time",       detail: "Choose a quiet 10–15 minute window with no distractions.",                                                isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Follow the Child",   detail: "Let your child choose the activity. Give no instructions — just follow their lead.",                      isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Describe & Imitate", detail: "Narrate what your child is doing like a sports announcer and copy their actions.",                        isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",     detail: "Builds confidence, independence, and a strong parent-child bond while reducing behavioural issues.",      isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Target Practice",
                description: "A fun throwing game that builds coordination and counting.",
                activityImage: "target_practice",
                durationMinutes: 10,
                ageRange: "4–6 yrs",
                materialsLabel: "Paper, tape",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Create Targets",  detail: "Cut holes in a cardboard box and assign point values to each hole.",           isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Take Turns",      detail: "Throw soft balls or beanbags from increasing distances.",                      isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Count the Score", detail: "Let the child add up points after each round — sneaky maths practice!",        isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",  detail: "Develops hand-eye coordination, gross motor skills, and basic addition.",      isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Feelings Check-In",
                description: "A quick daily ritual to name and share emotions together.",
                activityImage: "feelings_checkin",
                durationMinutes: 5,
                ageRange: "3–8 yrs",
                materialsLabel: "None needed",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Pick a Feeling",   detail: "Ask your child: 'What colour does your mood feel like today?' and share yours too.",   isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Name the Feeling",  detail: "Help them put a word to it — happy, nervous, excited, tired.",                         isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",    detail: "Builds emotional vocabulary and makes children feel heard every single day.",           isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Gratitude Jar",
                description: "Write or draw one thing you're grateful for and drop it in a jar.",
                activityImage: "gratitude_jar",
                durationMinutes: 5,
                ageRange: "4–10 yrs",
                materialsLabel: "Jar, paper, pen",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Decorate the Jar",  detail: "Let your child paint or sticker a glass jar to make it special.",                      isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Write Daily",        detail: "Each evening write one thing that made you happy on a slip of paper and add it.",      isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Read Together",      detail: "On weekends, read a few slips out loud together.",                                     isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",     detail: "Builds a gratitude mindset, positive thinking, and family connection.",               isExpanded: false)
                ]
            ),

            // ── MEDIUM (15–30 min)
            CollaborativeActivityList(
                id: UUID(),
                title: "Kitchen Science Lab",
                description: "Fun science experiment that introduces chemistry through play.",
                activityImage: "science_volcano",
                durationMinutes: 25,
                ageRange: "5–10 yrs",
                materialsLabel: "Vinegar, baking soda, food colour",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Prepare Materials",   detail: "Place a small bottle in a tray and fill it with baking soda and food colouring.",    isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Create the Reaction", detail: "Let the child slowly pour vinegar and watch the bubbling explosion.",                 isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Discuss Why",         detail: "Ask 'why do you think it bubbled?' and guide them to the acid-base idea.",            isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",      detail: "Teaches cause-and-effect and introduces science concepts visually.",                 isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Mealtime Math",
                description: "Use everyday meals to teach counting and measurement.",
                activityImage: "mealtime_math",
                durationMinutes: 20,
                ageRange: "4–6 yrs",
                materialsLabel: "Food, paper",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Count Items",       detail: "Ask your child to count plates, spoons, or glasses needed for the family.",            isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Estimate Volumes",  detail: "Let the child guess how many spoons of water will fill a cup.",                        isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Sort & Group",      detail: "Sort food by colour, shape, or size — a sneaky intro to classification.",              isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",    detail: "Builds early maths skills, estimation, and logical thinking.",                        isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Floating Ketchup",
                description: "Physics activity demonstrating pressure and buoyancy.",
                activityImage: "floating_ketchup",
                durationMinutes: 20,
                ageRange: "5–10 yrs",
                materialsLabel: "Ketchup packet, plastic bottle",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Set Up Bottle",     detail: "Fill a clear plastic bottle with water and drop in a ketchup packet.",                isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Squeeze & Release", detail: "Squeeze the bottle to make the packet sink and release to make it float.",            isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Guess Why",         detail: "Ask the child to predict what will happen before each squeeze.",                      isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",    detail: "Introduces density and pressure concepts through hands-on play.",                    isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Home Writing Center",
                description: "A creative space for early writing and communication.",
                activityImage: "writing_center",
                durationMinutes: 20,
                ageRange: "5–8 yrs",
                materialsLabel: "Paper, markers, envelopes",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Set Up Space",    detail: "Lay out paper, markers, envelopes, and crayons at a small table.",                     isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Write Together",  detail: "Help the child write letters, menus, or simple stories.",                              isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Post the Letter", detail: "Put a letter in an envelope and 'deliver' it to a family member.",                    isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",  detail: "Supports early literacy, creativity, and fine motor development.",                    isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Story Stones",
                description: "Paint rocks and use them to invent and tell stories together.",
                activityImage: "story_stones",
                durationMinutes: 25,
                ageRange: "4–9 yrs",
                materialsLabel: "Smooth rocks, paint, brushes",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Paint the Stones",  detail: "Paint simple pictures on smooth rocks — a sun, a house, a dog, a cloud.",            isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Build a Story",     detail: "Take turns picking a stone and adding a sentence to the story.",                     isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",    detail: "Sparks narrative thinking, turn-taking, and imaginative language.",                  isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Shadow Drawing",
                description: "Use sunlight and objects to trace and create shadow art.",
                activityImage: "shadow_drawing",
                durationMinutes: 20,
                ageRange: "4–8 yrs",
                materialsLabel: "Paper, pencil, sunlight",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Set Up Objects",   detail: "Place toys or household items on paper in sunlight near a window.",                   isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Trace the Shadow", detail: "Trace the shadow outline and then decorate it however the child likes.",              isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",   detail: "Teaches light and shadow concepts and develops fine motor control.",                  isExpanded: false)
                ]
            ),

            // ── LONG (30+ min)

            CollaborativeActivityList(
                id: UUID(),
                title: "Nature Scavenger Hunt",
                description: "An outdoor adventure that turns a walk into a learning experience.",
                activityImage: "nature_hunt",
                durationMinutes: 45,
                ageRange: "4–12 yrs",
                materialsLabel: "Checklist, basket",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Make a Checklist",  detail: "Create a list of items — a smooth rock, a Y-shaped stick, a yellow flower.",         isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Explore Together",  detail: "Walk through a park or garden and search for each item together.",                   isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Sort the Finds",    detail: "Back home, sort collected items by size, colour, or texture.",                       isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",    detail: "Improves observation skills, environmental awareness, and physical activity.",       isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "LEGO Museum Tour",
                description: "Building play combined with creative storytelling.",
                activityImage: "lego_museum",
                durationMinutes: 60,
                ageRange: "6–12 yrs",
                materialsLabel: "LEGO bricks",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Build Creations",  detail: "Let the child build anything they like — no rules on what to make.",                  isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Museum Tour",      detail: "Ask the child to explain each creation as if guiding visitors around a museum.",      isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Add Labels",       detail: "Write little title cards for each exhibit like a real museum.",                       isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",   detail: "Develops language skills, confidence, spatial reasoning, and storytelling.",         isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Egg Carton Caterpillar",
                description: "A recycled-material craft that builds fine motor skills.",
                activityImage: "egg_caterpillar",
                durationMinutes: 35,
                ageRange: "3–7 yrs",
                materialsLabel: "Egg carton, paint, pipe cleaners",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Prepare Carton",  detail: "Cut an egg carton into a strip — each cup becomes one segment of the caterpillar.",   isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Paint Together",  detail: "Let the child choose colours and paint each segment.",                                 isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Add Details",     detail: "Poke pipe cleaners through for antennae and draw a face on the front.",               isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",  detail: "Builds fine motor control, creativity, and pride in making something.",               isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Flashlight Storytelling",
                description: "A calm bedtime game using imagination and a torch.",
                activityImage: "flashlight_story",
                durationMinutes: 30,
                ageRange: "4–9 yrs",
                materialsLabel: "Torch / flashlight",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Dim the Room",    detail: "Turn off the lights and use a flashlight to illuminate objects one at a time.",       isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Create Stories",  detail: "Take turns telling a short story about whatever the light lands on.",                 isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Continue the Story", detail: "Each person must continue from where the last person left off.",                   isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",  detail: "Boosts language development, creativity, and emotional bonding.",                    isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "DIY Bird Feeder",
                description: "Build a simple bird feeder and observe birds together.",
                activityImage: "bird_feeder",
                durationMinutes: 40,
                ageRange: "5–12 yrs",
                materialsLabel: "Pine cone, peanut butter, birdseed",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Coat the Cone",    detail: "Roll a pine cone in peanut butter until fully covered.",                             isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Add Seeds",        detail: "Roll it in birdseed and tie a string around the top to hang it.",                   isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Observe Together", detail: "Hang it outside and keep a notebook to record which birds visit.",                  isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",   detail: "Teaches responsibility, patience, and appreciation for nature.",                    isExpanded: false)
                ]
            ),

            CollaborativeActivityList(
                id: UUID(),
                title: "Mini Garden Project",
                description: "Plant and grow a small herb or flower garden together.",
                activityImage: "mini_garden",
                durationMinutes: 45,
                ageRange: "4–12 yrs",
                materialsLabel: "Pot, soil, seeds or seedling",
                steps: [
                    CollaborativeActivitySteps(stepLabel: "Step 1", title: "Pick a Plant",     detail: "Let the child choose a seed — basil, sunflower, and marigold all grow quickly.",    isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 2", title: "Plant Together",   detail: "Fill a pot with soil, make a hole, drop in the seed, and cover it gently.",         isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Step 3", title: "Daily Care",       detail: "Assign the child as the official plant caretaker — water it every morning.",        isExpanded: false),
                    CollaborativeActivitySteps(stepLabel: "Benefits", title: "Why It Helps",   detail: "Teaches responsibility, patience, and the science of plant growth.",                isExpanded: false)
                ]
            )

        ]
    }

    

    private func loadHabits() {
        habits = [

            // FOUNDATIONAL
            HabitList(id: UUID(), title: "Brush Teeth",   icon: "tooth",             phase: .foundational, description: "Maintain daily oral hygiene",                traits: ["Hygiene","Discipline","Health"],          benefits: [], harms: []),
            HabitList(id: UUID(), title: "Make Bed",      icon: "bed.double",        phase: .foundational, description: "Build discipline by organising your space",  traits: ["Discipline","Responsibility","Order"],    benefits: [], harms: []),
            HabitList(id: UUID(), title: "Drink Water",   icon: "drop.fill",         phase: .foundational, description: "Stay hydrated throughout the day",           traits: ["Health","Awareness","Routine"],           benefits: [], harms: []),
            HabitList(id: UUID(), title: "Wash Hands",    icon: "hand.raised",       phase: .foundational, description: "Practice cleanliness and prevent illness",   traits: ["Cleanliness","Health","Awareness"],       benefits: [], harms: []),
            HabitList(id: UUID(), title: "Sleep on Time", icon: "moon.fill",         phase: .foundational, description: "Ensure proper rest and recovery",            traits: ["Discipline","Energy","Focus"],            benefits: [], harms: []),

            // GROWTH
            HabitList(id: UUID(), title: "Daily Reading",    icon: "book.fill",      phase: .growth, description: "Develop a consistent reading habit",              traits: ["Focus","Curiosity","Learning"],           benefits: [], harms: []),
            HabitList(id: UUID(), title: "Write Journal",    icon: "pencil",         phase: .growth, description: "Express thoughts and reflect daily",              traits: ["Reflection","Expression","Awareness"],    benefits: [], harms: []),
            HabitList(id: UUID(), title: "Practice Drawing", icon: "paintbrush",     phase: .growth, description: "Enhance creativity through drawing",              traits: ["Creativity","Patience","Expression"],     benefits: [], harms: []),

            // RESPONSIBILITY
            HabitList(id: UUID(), title: "Pack School Bag", icon: "backpack.fill",   phase: .responsibility, description: "Plan ahead for school responsibilities",  traits: ["Responsibility","Planning","Independence"], benefits: [], harms: []),
            HabitList(id: UUID(), title: "Clean Room",      icon: "house.fill",      phase: .responsibility, description: "Maintain cleanliness and ownership",      traits: ["Ownership","Order","Discipline"],          benefits: [], harms: []),
            HabitList(id: UUID(), title: "Help Parents",    icon: "person.2.fill",   phase: .responsibility, description: "Support family members at home",          traits: ["Empathy","Support","Gratitude"],           benefits: [], harms: []),

            // ACADEMICS
            HabitList(id: UUID(), title: "Solve Puzzles",    icon: "brain.head.profile", phase: .academics, description: "Improve logical and analytical skills",   traits: ["Logic","Problem Solving","Focus"],        benefits: [], harms: []),
            HabitList(id: UUID(), title: "Learn New Words",  icon: "text.book.closed",   phase: .academics, description: "Enhance vocabulary and language skills",  traits: ["Vocabulary","Memory","Learning"],         benefits: [], harms: []),
            HabitList(id: UUID(), title: "Math Practice",    icon: "plus.slash.minus",   phase: .academics, description: "Build confidence in mathematics",         traits: ["Accuracy","Logic","Confidence"],          benefits: [], harms: [])
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
