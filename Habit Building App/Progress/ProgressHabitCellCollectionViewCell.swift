//
//  ProgressHabitCell.swift
//  Habit Harmony
//

import UIKit

class ProgressHabitCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var daysLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = .white
    }

    func configure(with habit: Habit) {
        habitTitleLabel.text = habit.title

        let totalDays = 28
        let completedDays = habit.assignedDates.count
        let progress = Float(completedDays) / Float(totalDays)

        progressBar.progress = progress
        daysLabel.text = "\(completedDays)/\(totalDays) days"
    }
}
