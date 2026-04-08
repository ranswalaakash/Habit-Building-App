//
//  CollaborativeActivitiesListViewController.swift
//  Habit Harmony
//
//  Created by GEU on 06/02/26.
//

import UIKit


class CollaborativeActivitiesListViewController: UIViewController {
    @IBOutlet weak var collaborativeActivitiesCollectionView: UICollectionView!
    private var allActivities: [CollaborativeActivityList] = []
    private var filteredActivities: [CollaborativeActivityList] = []
    private var selectedFilter: String = "all"
    
    private var selectedActivity: CollaborativeActivityList?
    var selectedTime: String? = nil
    var selectedAge: String? = nil
    var selectedMaterial: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupCollectionView()
        setupFilterMenu()
        
    }
    
    private func setupData() {
        allActivities = HabitDataModel.shared.getCollaborativeActivities()
        filteredActivities = allActivities
    }
    func setupFilterMenu() {
        
        let timeMenu = UIAction(
            title: "Time",
            state: selectedTime != nil ? .on : .off
        ) { _ in
            
            if self.selectedTime != nil {
                // 🔥 TOGGLE OFF
                self.selectedTime = nil
                self.applyAdvancedFilter()
                self.setupFilterMenu()
            } else {
                // 🔥 OPEN OPTIONS
                self.showTimeFilter()
            }
        }
        
        let ageMenu = UIAction(
            title: "Age",
            state: selectedAge != nil ? .on : .off
        ) { _ in
            
            if self.selectedAge != nil {
                self.selectedAge = nil
                self.applyAdvancedFilter()
                self.setupFilterMenu()
            } else {
                self.showAgeFilter()
            }
        }
        
        let materialMenu = UIAction(
            title: "Materials",
            state: selectedMaterial != nil ? .on : .off
        ) { _ in
            
            if self.selectedMaterial != nil {
                self.selectedMaterial = nil
                self.applyAdvancedFilter()
                self.setupFilterMenu()
            } else {
                self.showMaterialFilter()
            }
        }
        
        let clear = UIAction(title: "Clear All", attributes: .destructive) { _ in
            self.selectedTime = nil
            self.selectedAge = nil
            self.selectedMaterial = nil
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        }
        
        let menu = UIMenu(title: "", children: [
            timeMenu,
            ageMenu,
            materialMenu,
            UIMenu(title: "", options: .displayInline, children: [clear])
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            primaryAction: nil,
            menu: menu
        )
    }
    
    func showTimeFilter() {
        
        let alert = UIAlertController(title: "Select Time", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Under 15 min", style: .default) { _ in
            
            if self.selectedTime == "quick" {
                self.selectedTime = nil   // toggle OFF
            } else {
                self.selectedTime = "quick"
            }
            
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        })
        
        alert.addAction(UIAlertAction(title: "15–30 min", style: .default) { _ in
            
            if self.selectedTime == "medium" {
                self.selectedTime = nil
            } else {
                self.selectedTime = "medium"
            }
            
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        })
        
        alert.addAction(UIAlertAction(title: "30+ min", style: .default) { _ in
            
            if self.selectedTime == "long" {
                self.selectedTime = nil
            } else {
                self.selectedTime = "long"
            }
            
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func showAgeFilter() {
        
        let alert = UIAlertController(title: "Select Age", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "3+ yrs", style: .default) { _ in
            
            if self.selectedAge == "3" {
                self.selectedAge = nil
            } else {
                self.selectedAge = "3"
            }
            
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        })
        
        alert.addAction(UIAlertAction(title: "6+ yrs", style: .default) { _ in
            
            if self.selectedAge == "6" {
                self.selectedAge = nil
            } else {
                self.selectedAge = "6"
            }
            
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        })
        
        alert.addAction(UIAlertAction(title: "9+ yrs", style: .default) { _ in
            
            if self.selectedAge == "9" {
                self.selectedAge = nil
            } else {
                self.selectedAge = "9"
            }
            
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func showMaterialFilter() {
        
        let alert = UIAlertController(title: "Materials", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "No materials needed", style: .default) { _ in
            
            if self.selectedMaterial == "no_material" {
                self.selectedMaterial = nil
            } else {
                self.selectedMaterial = "no_material"
            }
            
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        })
        
        alert.addAction(UIAlertAction(title: "Materials required", style: .default) { _ in
            
            if self.selectedMaterial == "required" {
                self.selectedMaterial = nil
            } else {
                self.selectedMaterial = "required"
            }
            
            self.applyAdvancedFilter()
            self.setupFilterMenu()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func isAgeMatch(activityRange: String, selectedAge: String) -> Bool {
        
        let numbers = activityRange
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .compactMap { Int($0) }
        
        guard numbers.count >= 2 else { return false }
        
        let minAge = numbers[0]
        let maxAge = numbers[1]
        
        guard let selected = Int(selectedAge) else { return false }
        
        return selected >= minAge && selected <= maxAge
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
            
            // ITEM (FULL WIDTH)
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 8,
                bottom: 8,
                trailing: 8
            )
            
            // GROUP (ONE ITEM ONLY 🔥)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(310)
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
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
    extension CollaborativeActivitiesListViewController {
        
        func applyAdvancedFilter() {
            
            filteredActivities = allActivities.filter { activity in
                
                var matches = true
                
                // TIME
                if let time = selectedTime {
                    matches = matches && (activity.timeCategory == time)
                }
                
                // AGE
                if let age = selectedAge, let selected = Int(age) {
                    matches = matches && (activity.preferredAge >= selected)
                }
                
                // MATERIAL
                if let material = selectedMaterial {
                        
                        if material == "no_material" {
                            matches = matches && (activity.needsMaterials == false)
                        } else if material == "required" {
                            matches = matches && (activity.needsMaterials == true)
                        }
                }
                
                return matches
            }
            
            collaborativeActivitiesCollectionView.reloadData()
        }
    }
