//
//  CollaborativeList.swift
//  Habit Harmony
//
//  Created by GEU on 05/02/26.
//

import UIKit

class CollaborativeActivityListCell: UICollectionViewCell {

    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardUI()
    }

    private func setupCardUI() {

        // Card shape
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white

        // Shadow must be on cell layer (NOT contentView)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }

    func configureCell(with activity: CollaborativeActivityList) {
        titleLabel.text = activity.title
        activityImage.image = UIImage(named: activity.activityImage)
    }
}
