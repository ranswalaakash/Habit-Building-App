//
//  AddRewardViewController.swift
//  Habit Harmony
//
//  Created by GEU on 16/03/26.
//

import UIKit

class AddRewardVC: UIViewController {

    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    var reward: Reward?
    var onSave: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        rewardLabel.text = reward?.name
    }

    @IBAction func doneTapped(_ sender: UIBarButtonItem) {

        let selectedDate = datePicker.date
        onSave?(selectedDate)

        dismiss(animated: true)
    }

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

