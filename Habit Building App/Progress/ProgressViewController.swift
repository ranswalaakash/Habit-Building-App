//
//  ProgressViewController.swift
//  Habit Harmony
//

import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var habits: [Habit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        habits = HabitDataModel.shared.getUserAddedHabits()
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        collectionView.register(
            UINib(nibName: "ProgressHabitCellCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ProgressHabitCell"
        )

        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "ProgressHeader"
        )

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }

    private func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(110)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 6, leading: 16, bottom: 6, trailing: 16
            )

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(110)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 8, leading: 0, bottom: 8, trailing: 0
            )

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]

            return section
        }
    }

}

extension ProgressViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return habits.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProgressHabitCell",
            for: indexPath
        ) as! ProgressHabitCellCollectionViewCell

        cell.configure(with: habits[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "ProgressHeader",
            for: indexPath
        )

        header.subviews.forEach { $0.removeFromSuperview() }
        header.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = "Everyday Habits"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let viewMoreButton = UIButton(type: .system)
        viewMoreButton.setTitle("View More", for: .normal)
        viewMoreButton.setTitleColor(UIColor(red: 0.35, green: 0.35, blue: 1.0, alpha: 1.0), for: .normal)
        viewMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        viewMoreButton.translatesAutoresizingMaskIntoConstraints = false

        header.addSubview(titleLabel)
        header.addSubview(viewMoreButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            viewMoreButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20),
            viewMoreButton.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])

        return header
    }
}

extension ProgressViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let habit = habits[indexPath.row]
        performSegue(withIdentifier: "progress_to_detail", sender: habit)
    }
}
