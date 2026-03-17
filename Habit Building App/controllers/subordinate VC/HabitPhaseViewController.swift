//
//  HabitPhaseViewController.swift
//  Habit Harmony
//
//  Created by GEU on 02/02/26.
//

import UIKit

class HabitPhaseViewController: UIViewController {

    @IBOutlet weak var phaseCollectionView: UICollectionView!
    
    let dataModel = HabitDataModel.shared
    var phases: [HabitPhase] = []
    var selectedPhase: HabitPhaseType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load data
        phases = dataModel.getPhases()

        // CollectionView setup
        phaseCollectionView.dataSource = self
        phaseCollectionView.delegate = self

        phaseCollectionView.backgroundColor = UIColor.systemGroupedBackground
        phaseCollectionView.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.systemGroupedBackground
        phaseCollectionView.backgroundColor = UIColor.systemGroupedBackground
        
        registerCell()

        // Apply compositional layout
        phaseCollectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }

    func registerCell() {

        phaseCollectionView.register(
            UINib(nibName: "HabitPhasesCell", bundle: nil),
            forCellWithReuseIdentifier: "habit_phases_cell"
        )

        phaseCollectionView.register(
            UINib(nibName: "PhasesTitleCell", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "PhasesTitleCell"
        )
    }
}

extension HabitPhaseViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return phases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "habit_phases_cell",
            for: indexPath
        ) as! HabitPhasesCell

        let phase = phases[indexPath.row]
        cell.configureCell(with: phase)

        return cell
    }

    // Header

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "PhasesTitleCell",
            for: indexPath
        ) as! PhasesTitleCell

        headerView.configure(with: "Choose Phase")

        return headerView
    }
}

extension HabitPhaseViewController {

    func generatePhaseSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 10,
            trailing: 16
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(190)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 0,
            bottom: 24,
            trailing: 0
        )

        // Header

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [header]

        return section
    }

    func generateLayout() -> UICollectionViewLayout {

        return UICollectionViewCompositionalLayout { sectionIndex, env in
            return self.generatePhaseSection()
        }
    }
}

extension HabitPhaseViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let phase = phases[indexPath.row]
        selectedPhase = phase.type

        performSegue(withIdentifier: "phases_to_habits", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "phases_to_habits" {

            let vc = segue.destination as! HabitListViewController
            vc.selectedPhase = selectedPhase
        }
    }
}
