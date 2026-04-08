//
//  ViewRewardTableViewCell.swift
//  Habit Harmony
//
//  Created by GEU on 17/03/26.
//

import UIKit

class ViewRewardTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    func configure(with entry: RewardEntry) {

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        dateLabel.text = formatter.string(from: entry.date)
        statusLabel.text = "Redeemed"
    }
}
