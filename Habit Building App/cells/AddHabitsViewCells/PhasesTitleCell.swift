//
//  PhasesTitle.swift
//  Habit Harmony
//
//  Created by GEU on 02/02/26.
//

import UIKit

class PhasesTitleCell: UICollectionViewCell {
    @IBOutlet weak var titelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with title: String) {
        titelLabel.text = title
    }
}
