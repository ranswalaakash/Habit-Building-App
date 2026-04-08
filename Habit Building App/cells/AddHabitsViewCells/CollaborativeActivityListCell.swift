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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var materialsLabel: UILabel!

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
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        layer.masksToBounds = false
        
        activityImage.layer.cornerRadius = 16
        activityImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        activityImage.clipsToBounds = true
        
    }

    func configureCell(with activity: CollaborativeActivityList) {
        titleLabel.text = activity.title
        activityImage.image = UIImage(named: activity.activityImage)

        timeLabel.text = "\(activity.timeLabel)"
        ageLabel.text = "\(activity.preferredAge)+ yrs"
        materialsLabel.text = "\(activity.materialsLabel)"

        ageLabel.layer.cornerRadius = 10
        ageLabel.layer.masksToBounds = true
    }
}


class PaddingLabel: UILabel {

    let padding = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
