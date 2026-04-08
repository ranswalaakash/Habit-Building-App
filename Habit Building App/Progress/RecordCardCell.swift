//
//  RecordCardCell.swift
//  Habit Harmony
//

import UIKit

class RecordCardCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
    }

    func configure(icon: String, number: Int, description: String) {
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = UIColor(red: 0.35, green: 0.35, blue: 1.0, alpha: 1.0)
        numberLabel.text = "\(number)"
        descriptionLabel.text = description
        descriptionLabel.textAlignment = .center
    }
}
