//
//  CollaborativeActivityStepsTableViewCell.swift
//  Habit Harmony
//
//  Created by GEU on 07/02/26.
//

import UIKit

class CollaborativeActivityStepCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupCard()
    }

    private func setupCard() {

        cardView.layer.cornerRadius = 16
        cardView.backgroundColor = UIColor.secondarySystemGroupedBackground

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)

        stepLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        stepLabel.textColor = .systemBlue

        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label

        detailLabel.font = UIFont.systemFont(ofSize: 15)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0
    }

    func configure(with model: CollaborativeActivitySteps, isExpanded: Bool) {

        stepLabel.text = model.stepLabel
        titleLabel.text = model.title
        detailLabel.text = model.detail

        detailLabel.isHidden = !isExpanded

        let symbol = isExpanded ? "chevron.up" : "chevron.down"

        UIView.transition(
            with: chevronImageView,
            duration: 0.2,
            options: .transitionCrossDissolve
        ) {
            self.chevronImageView.image = UIImage(systemName: symbol)
        }

        cardView.backgroundColor = isExpanded
        ? UIColor.systemBlue.withAlphaComponent(0.10)
        : UIColor.secondarySystemGroupedBackground
    }
}
