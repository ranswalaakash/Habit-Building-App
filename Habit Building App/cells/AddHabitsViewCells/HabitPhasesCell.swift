//
//  HabitPhases.swift
//  Habit Harmony
//
//  Created by GEU on 02/02/26.
//

import UIKit

class HabitPhasesCell: UICollectionViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        cardView.layer.cornerRadius = 22
        cardView.backgroundColor = UIColor.secondarySystemGroupedBackground

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)
                
        cardView.layer.masksToBounds = false
    }

    func configureCell(with phase: HabitPhase) {

        titleLabel.text = phase.title
        subtitleLabel.text = phase.subtitle

        iconImage.image = UIImage(systemName: phase.icon)
        
        // Icon styling
        iconImage.image = UIImage(systemName: phase.icon)
        iconImage.tintColor = phase.color
        iconImage.backgroundColor = phase.color.withAlphaComponent(0.2)
        iconImage.layer.cornerRadius = 12
        iconImage.clipsToBounds = true

        progressBar.progressTintColor = phase.color
        progressBar.trackTintColor = UIColor.systemGray5
        progressBar.progress = 0.6
        progressLabel.text = "60"
    }
}
