import Foundation

class HabitStore {

    static let shared = HabitStore()
    private init() {}

    private(set) var parentHabits: [Habit] = []

    var onHabitsUpdated: (() -> Void)?
    var onHabitApproved: (() -> Void)?

    func addHabit(title: String, icon: String) {
        let id = UUID().uuidString

        let parentHabit = Habit(
            habitId: id,
            title: title,
            status: .notDone,
            assignedDates: []
        )
        parentHabits.append(parentHabit)

        onHabitsUpdated?()
    }


    func parentApproved(habitId: String) {
        if let pi = parentHabits.firstIndex(where: { $0.habitId == habitId }) {
            parentHabits[pi].status = .approved
        }
        onHabitsUpdated?()
        onHabitApproved?()
    }

    func parentRejected(habitId: String) {
        if let pi = parentHabits.firstIndex(where: { $0.habitId == habitId }) {
            parentHabits[pi].status = .notDone
        }
        onHabitsUpdated?()
    }
}
