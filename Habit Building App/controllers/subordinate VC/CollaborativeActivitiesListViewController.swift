//
//  CollaborativeActivitiesListViewController.swift
//  Habit Harmony
//
//  Created by GEU on 06/02/26.
//

import UIKit

import UIKit

class CollaborativeActivitiesListViewController: UIViewController {

    @IBOutlet weak var collaborativeActivitiesCollectionView: UICollectionView!

    // MARK: - Data Source
    private let collaborativeActivities: [CollaborativeActivityList] = HabitDataModel.shared.getCollaborativeActivities()
    private var selectedActivity: CollaborativeActivityList?
    var activity: CollaborativeActivityList?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        collaborativeActivitiesCollectionView.delegate = self
    }

    private func setupCollectionView() {
        collaborativeActivitiesCollectionView.setCollectionViewLayout(
                generateCollaborativeLayout(),
                animated: false
            )
        collaborativeActivitiesCollectionView.dataSource = self
        collaborativeActivitiesCollectionView.register(
            UINib(nibName: "CollaborativeActivityListCell", bundle: nil),
            forCellWithReuseIdentifier: "collaborative_list_cell"
        )
    }
}

extension CollaborativeActivitiesListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return collaborativeActivities.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "collaborative_list_cell",
            for: indexPath
        ) as! CollaborativeActivityListCell
        
        cell.configureCell(with: collaborativeActivities[indexPath.item])
        return cell
    }
    
    func generateCollaborativeLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { _, _ in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 8,
                bottom: 8,
                trailing: 8
            )
            
            // Row (2 cards)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(190)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item, item]
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 16,
                leading: 8,
                bottom: 16,
                trailing: 8
            )
            
            return section
        }
    }
}

extension CollaborativeActivitiesListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        selectedActivity = collaborativeActivities[indexPath.item]
        performSegue(withIdentifier: "collaborative_to_steps", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "collaborative_to_steps" {
            let vc = segue.destination as! CollaborativeActivityStepsViewController
            vc.activity = selectedActivity
        }
    }
}


