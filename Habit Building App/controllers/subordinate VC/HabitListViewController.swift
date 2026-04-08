//
//  HabitListViewController.swift
//  Habit Harmony
//
//  Created by GEU on 02/02/26.
//

import UIKit

class HabitListViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var habitsCollectionView: UICollectionView!

    let dataModel = HabitDataModel.shared
        var selectedPhase: HabitPhaseType?
        var filteredHabits: [HabitList] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let phase = selectedPhase else {
            fatalError("Phase not passed")
        }
        
        filteredHabits = dataModel.getHabits(for: phase)
        navigationItem.title = titleForPhase(phase)
        
        habitsCollectionView.register(
            UINib(nibName: "HabitListCell", bundle: nil),
            forCellWithReuseIdentifier: "habit_list_cells"
        )
        
        habitsCollectionView.dataSource = self
        habitsCollectionView.delegate = self
        habitsCollectionView.setCollectionViewLayout(generateHabitListLayout(), animated: true)
    }


    func titleForPhase(_ phase: HabitPhaseType) -> String {
        switch phase {
        case .foundational: return "Foundational Habits"
        case .growth: return "Growth Habits"
        case .responsibility: return "Responsibility Habits"
        case .academics: return "Academic Habits"
        }
    }
}

extension HabitListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filteredHabits.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habit_list_cells", for: indexPath) as! HabitListCell
        let habit = filteredHabits[indexPath.row]
        cell.configureCell(with: habit)
        return cell
    }
    
    func generateHabitListSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Space inside each card
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 0,
            bottom: 8,
            trailing: 0
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(150)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        // Space between cards
        section.interGroupSpacing = 12
        
        // Space from screen edges
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )

        return section
    }
    
    func generateHabitListLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            return self.generateHabitListSection()
        }
    }

}

extension HabitListViewController {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        performSegue(
            withIdentifier: "habit_list_to_description",
            sender: indexPath
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "habit_list_to_description",
           let indexPath = sender as? IndexPath,
           let destination = segue.destination as? HabitDescription {

            let selectedHabit = filteredHabits[indexPath.row]
            destination.habit = selectedHabit
        }
    }
}



