//
//  CollaborativeActivities.swift
//  Habit Harmony
//
//  Created by GEU on 02/02/26.
//

import UIKit

class CollaborativeSpaceCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with item: CollaborativePhase) {
        iconImage.image = UIImage(named: item.iconImage)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        
        contentView.backgroundColor = .systemPurple
        contentView.layer.cornerRadius = 20
    }
}
