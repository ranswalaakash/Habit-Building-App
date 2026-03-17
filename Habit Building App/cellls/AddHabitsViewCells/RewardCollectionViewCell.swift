//
//  RewardListCollectionViewCell.swift
//  reward Cells
//
//  Created by Aakash Singh Ranswal on 16/03/26.
//

import UIKit

class RewardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
            super.awakeFromNib()

            contentView.layer.cornerRadius = 14
            contentView.layer.borderWidth = 0.5
            contentView.layer.borderColor = UIColor.systemGray4.cgColor

            contentView.backgroundColor = .secondarySystemBackground

            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.08
            layer.shadowRadius = 6
            layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    
    func configure(with reward: Reward) {
        titleLabel.text = reward.name

        let count = reward.redeemCount

        if count == 0 {
            subtitleLabel.text = "Not redeemed yet"
        } else if count == 1 {
            subtitleLabel.text = "Redeemed 1 time"
        } else {
            subtitleLabel.text = "Redeemed \(count) times"
        }
    }
}
