//
//  TodayViewController.swift
//  Habit Harmony
//

import UIKit

class TodayViewController: UIViewController,
                            UITableViewDataSource,
                            UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var parentProfileButton: UIButton!
    private var habits: [Habit] = []
    private var selectedDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadHabits()
    }
    private func setupTableView() {
        tableView.register(
            UINib(nibName: "CalendarTableViewCell", bundle: nil),
            forCellReuseIdentifier: "CalendarTableViewCell"
        )
        tableView.register(
            UINib(nibName: "HabitTableViewCell", bundle: nil),
            forCellReuseIdentifier: "HabitTableViewCell"
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
    private func showApprovalPopup(for habit: Habit) {
        let alert = UIAlertController(
            title: "🌟 Habit Completed!",
            message: "Your child completed:\n\"\(habit.title)\"\n\nDo you approve?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "✅ Approve", style: .default) { _ in
            HabitStore.shared.parentApproved(habitId: habit.habitId)
        })
        
        alert.addAction(UIAlertAction(title: "❌ Reject", style: .destructive) { _ in
            HabitStore.shared.parentRejected(habitId: habit.habitId)
        })
        
        present(alert, animated: true)
    }

    private func reloadHabits() {
        habits = HabitDataModel.shared.getHabits(for: selectedDate)
        tableView.reloadData()
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Temp", bundle: nil)
        guard let habitPhaseVC = storyboard.instantiateViewController(
            withIdentifier: "Add"
        ) as? HabitPhaseViewController else { return }
        navigationController?.pushViewController(habitPhaseVC, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : habits.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CalendarTableViewCell",
                for: indexPath
            ) as! CalendarTableViewCell

            cell.onDateSelected = { [weak self] date in
                self?.selectedDate = date
                self?.reloadHabits()
            }
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "HabitTableViewCell",
                for: indexPath
            ) as! HabitTableViewCell

            cell.configure(with: habits[indexPath.row])
            return cell
        }
    }

    @IBAction func parentProfileTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 320 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }

        let header = UIView()
        header.backgroundColor = .clear

        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            label.text = "Today's Habit Check"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            label.text = "Habits for \(formatter.string(from: selectedDate))"
        }

        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])

        return header
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 50 : 0
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
