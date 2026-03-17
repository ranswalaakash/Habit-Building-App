//
//  RewardBoardViewController.swift
//  reward Cells
//
//  Created by Aakash Singh Ranswal on 16/03/26.
//

import UIKit

class RewardBoardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var rewards: [Reward] = sampleRewards

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.register(UINib(nibName: "RewardCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "reward_cell")
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func addRewardTapped(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddNewRewardViewController")
        
        present(vc, animated: true)
    }
}

extension RewardBoardViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return rewards.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "reward_cell",
            for: indexPath
        ) as! RewardCollectionViewCell

        let reward = rewards[indexPath.item]
        cell.configure(with: reward)

        return cell
    }
}

extension RewardBoardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let reward = rewards[indexPath.item]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "view_rewards") as! ViewReward

        vc.reward = reward

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        // ITEM
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)
        
        
        // GROUP
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(90)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        
        // SECTION
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
