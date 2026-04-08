//
//  AddHabitTableViewController.swift
//  Habit Harmony
//

import UIKit

final class AddHabitTableViewController: UITableViewController {

    enum HabitFormMode {
        case add
        case edit
    }

    var mode: HabitFormMode = .add
    var habitTemplate: HabitList?

    private var selectedPeriod: Int = 21

    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var habitDescriptionTextField: UITextField!
    @IBOutlet weak var periodButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        populateFromTemplateIfNeeded()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Add Habit"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )
    }

    @objc private func cancelTapped() {
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }

    @objc private func doneTapped() {
           guard let name = habitNameTextField.text, !name.isEmpty else {
               print("DEBUG: name is empty, returning")
               return
           }
        let description = habitDescriptionTextField.text ?? ""

        let assignedDates = generateDates(for: selectedPeriod)

        switch mode {

        case .add:
            let habitList = HabitList(
                id: UUID().uuidString,
                title: name,
                icon: habitTemplate?.icon ?? "star",
                phase: habitTemplate?.phase ?? .growth,
                description: description,
                traits: habitTemplate?.traits ?? [],
                benefits: habitTemplate?.benefits ?? [],
                harms: habitTemplate?.harms ?? [],
//                points:0,
//                periodInDays: selectedPeriod
            )
            HabitDataModel.shared.addHabit(habitList)

            let todayHabit = Habit(
                habitId: habitList.id,
                title: name,
                status: .notDone,
                assignedDates: assignedDates
            )
            HabitDataModel.shared.addUserHabit(todayHabit)
            HabitStore.shared.addHabit(title: name, icon: habitTemplate?.icon ?? "star")
          
        case .edit:
            guard var updatedHabit = habitTemplate else { return }
            updatedHabit.title = name
            updatedHabit.description = description
//            updatedHabit.periodInDays = selectedPeriod
            HabitDataModel.shared.updateHabit(updatedHabit)

            let todayHabit = Habit(
                habitId: updatedHabit.id,
                title: name,
                status: .notDone,
                assignedDates: assignedDates
            )
            HabitDataModel.shared.addUserHabit(todayHabit)
            HabitStore.shared.addHabit(title: name, icon: updatedHabit.icon)
        }

        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }

    private func setupUI() {
        configurePeriodButton()
        setupPeriodMenu()
    }

    private func populateFromTemplateIfNeeded() {
        guard let habit = habitTemplate else { return }
        habitNameTextField.text = habit.title
        habitDescriptionTextField.text = habit.description
//        selectedPeriod = habit.periodInDays
        updatePeriodButton()
    }

    private func generateDates(for days: Int) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let today = Date()
        for i in 0..<days {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
        return dates
    }

    private func showCustomPeriodAlert() {
        let alert = UIAlertController(
            title: "Custom Period",
            message: "Enter number of days",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "e.g. 10"
            textField.keyboardType = .numberPad
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let text = alert.textFields?.first?.text,
               let days = Int(text), days > 0 {
                self.selectedPeriod = days
                self.updatePeriodButton()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension AddHabitTableViewController {

    private func configurePeriodButton() {
        var config = UIButton.Configuration.plain()
        config.title = "\(selectedPeriod) days"
        config.image = UIImage(systemName: "chevron.up.chevron.down")
        config.imagePlacement = .trailing
        config.imagePadding = 6
        periodButton.configuration = config
    }

    private func setupPeriodMenu() {
        let values = [7, 14, 21, 30, 45, 60]

        var actions = values.map { value in
            UIAction(title: "\(value) days") { _ in
                self.selectedPeriod = value
                self.updatePeriodButton()
            }
        }

        let customAction = UIAction(title: "Custom") { _ in
            self.showCustomPeriodAlert()
        }
        actions.append(customAction)

        periodButton.menu = UIMenu(options: .singleSelection, children: actions)
        periodButton.showsMenuAsPrimaryAction = true
    }

    private func updatePeriodButton() {
        periodButton.configuration?.title = "\(selectedPeriod) days"
    }
}
