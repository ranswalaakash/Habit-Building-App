//
//  HabitListCollectionViewCell.swift
//  Habit Harmony
//
//  Created by GEU on 02/02/26.
//

import UIKit


class HabitListCell: UICollectionViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var traitLabel1: UILabel!
    @IBOutlet weak var traitLabel2: UILabel!
    @IBOutlet weak var traitLabel3: UILabel!
    @IBOutlet weak var mainCardView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainCardView.layer.cornerRadius = 16
        mainCardView.layer.shadowColor = UIColor.black.cgColor
        mainCardView.layer.shadowOpacity = 0.1
        mainCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainCardView.layer.shadowRadius = 8
        mainCardView.backgroundColor = .systemGray6
    }

    func configureCell(with habit: HabitList) {
        iconImage.image = UIImage(systemName: habit.icon)
        titleLabel.text = habit.title
        
        // Safe assignment
        let traits = habit.traits
        
        traitLabel1.text = traits.count > 0 ? traits[0] : ""
        traitLabel2.text = traits.count > 1 ? traits[1] : ""
        traitLabel3.text = traits.count > 2 ? traits[2] : ""
    }
}

