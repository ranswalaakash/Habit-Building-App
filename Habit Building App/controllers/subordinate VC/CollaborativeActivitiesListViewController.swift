//
//  CollaborativeActivitiesListViewController.swift
//  Habit Harmony
//
//  Created by GEU on 06/02/26.
//

import UIKit


class CollaborativeActivitiesListViewController: UIViewController {

    @IBOutlet weak var collaborativeActivitiesCollectionView: UICollectionView!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    private var allActivities: [CollaborativeActivityList] = []
        private var filteredActivities: [CollaborativeActivityList] = []
        private var selectedFilter: String = "all"
        
        private var selectedActivity: CollaborativeActivityList?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupData()
            setupCollectionView()
            
        }

        private func setupData() {
            allActivities = HabitDataModel.shared.getCollaborativeActivities()
            filteredActivities = allActivities
        }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0: selectedFilter = "all"
        case 1: selectedFilter = "quick"
        case 2: selectedFilter = "medium"
        case 3: selectedFilter = "long"
        default: break
        }

        applyFilter(type: selectedFilter)
    }
    
        private func setupCollectionView() {
            
            collaborativeActivitiesCollectionView.delegate = self
            collaborativeActivitiesCollectionView.dataSource = self
            
            collaborativeActivitiesCollectionView.setCollectionViewLayout(
                generateCollaborativeLayout(),
                animated: false
            )
            
            collaborativeActivitiesCollectionView.register(
                UINib(nibName: "CollaborativeActivityListCell", bundle: nil),
                forCellWithReuseIdentifier: "collaborative_list_cell"
            )
        }

        // MARK: - Layout (FIXED 🔥)
        private func generateCollaborativeLayout() -> UICollectionViewLayout {
            
            return UICollectionViewCompositionalLayout { _, _ in
                
                // ITEM
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
                
                // GROUP (FIX HEIGHT HERE 👇)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(260) // 🔥 INCREASED from 190
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item, item]
                )
                
                // SECTION
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 16,
                    leading: 12,
                    bottom: 20,
                    trailing: 12
                )
                
                return section
            }
        }
    }

    // MARK: - DataSource
    extension CollaborativeActivitiesListViewController: UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView,
                            numberOfItemsInSection section: Int) -> Int {
            return filteredActivities.count
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "collaborative_list_cell",
                for: indexPath
            ) as! CollaborativeActivityListCell
            
            let activity = filteredActivities[indexPath.item]
            cell.configureCell(with: activity)
            
            return cell
        }
    }

    extension CollaborativeActivitiesListViewController: UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView,
                            didSelectItemAt indexPath: IndexPath) {
            
            selectedActivity = filteredActivities[indexPath.item]
            performSegue(withIdentifier: "collaborative_to_steps", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "collaborative_to_steps" {
                let vc = segue.destination as! CollaborativeActivityStepsViewController
                vc.activity = selectedActivity
            }
        }
    }

    // MARK: - FILTER (READY FOR NEXT STEP 🚀)
    extension CollaborativeActivitiesListViewController {
        
        func applyFilter(type: String) {
            
            switch type {
            case "quick":
                filteredActivities = allActivities.filter { $0.timeCategory == "quick" }
                
            case "medium":
                filteredActivities = allActivities.filter { $0.timeCategory == "medium" }
                
            case "long":
                filteredActivities = allActivities.filter { $0.timeCategory == "long" }
                
            default:
                filteredActivities = allActivities
            }
            
            collaborativeActivitiesCollectionView.reloadData()
        }
    }
