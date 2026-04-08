//
//  HabitTableViewCell.swift
//  Habit Harmony
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            cardView.layer.cornerRadius = 16
            cardView.clipsToBounds = true
            selectionStyle = .none
            
            cardView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
                cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
                cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                cardView.heightAnchor.constraint(equalToConstant: 56)
            ])
    }
    
    func configure(with habit: Habit) {
        habitTitleLabel.text = habit.title
        
        switch habit.status {
        case .notDone:
            statusLabel.text = "Not Done Yet"
            statusLabel.textColor = .gray
            cardView.backgroundColor = UIColor.systemGray5

        case .pendingApproval:
            statusLabel.text = "⏳ Waiting Approval"
            statusLabel.textColor = .systemOrange
            cardView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)

        case .approved:
            statusLabel.text = "Approved"
            statusLabel.textColor = .systemGreen
            cardView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)

        case .rejected:
            statusLabel.text = "Rejected"
            statusLabel.textColor = .systemRed
            cardView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
        }
    }
    
}

