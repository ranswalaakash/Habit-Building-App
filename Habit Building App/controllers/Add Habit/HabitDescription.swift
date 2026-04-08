//
//  HabitDescription.swift
//  Habit Harmony
//
//  Created by GEU on 12/02/26.
//

import UIKit

class HabitDescription: UIViewController {

    var habit: HabitList?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            configureUI()
        }


        private func configureUI() {
            guard let habit else { return }
            titleLabel.text = habit.title
            descriptionLabel.text = habit.description
        }

    @IBAction func addHabitTapped(_ sender: UIButton) {
        guard presentedViewController == nil else { return }
        performSegue(withIdentifier: "habit_description_to_add_habit", sender: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "habit_description_to_add_habit",
           let navController = segue.destination as? UINavigationController,
           let addHabitVC = navController.topViewController as? AddHabitTableViewController {
            addHabitVC.mode = .edit
            addHabitVC.habitTemplate = habit
        }
    }
    }
