//
//  HabitDetailViewController.swift
//  Habit Harmony
//

import UIKit

class HabitDetailViewController: UICollectionViewController {

    var habit: Habit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
    }

    private func setupNavigationBar() {
        title = habit?.title ?? "Habit Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 1.0, alpha: 1.0)

        collectionView.register(
            UINib(nibName: "CalendarDetailCell", bundle: nil),
            forCellWithReuseIdentifier: "CalendarDetailCell"
        )

        collectionView.register(
            UINib(nibName: "RecordCardCell", bundle: nil),
            forCellWithReuseIdentifier: "RecordCardCell"
        )

        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "RecordsHeader"
        )

        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }

    private func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in

            if sectionIndex == 0 {
                // Calendar section
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(380)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 12, leading: 16, bottom: 12, trailing: 16
                )

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(380)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item]
                )

                return NSCollectionLayoutSection(group: group)

            } else {
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .absolute(140)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 8, leading: 8, bottom: 8, trailing: 8
                )

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(140)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item, item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 8, leading: 8, bottom: 8, trailing: 8
                )

               
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50)
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

    private func daysInCurrentMonth() -> Int {
        guard let dates = habit?.assignedDates else { return 0 }
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        return dates.filter {
            calendar.component(.month, from: $0) == currentMonth &&
            calendar.component(.year, from: $0) == currentYear
        }.count
    }

    private func totalDaysDone() -> Int {
        return habit?.assignedDates.count ?? 0
    }

    private func currentStreak() -> Int {
        guard let dates = habit?.assignedDates, !dates.isEmpty else { return 0 }
        let calendar = Calendar.current
        let sortedDates = dates.sorted()
        var streak = 1
        var currentDate = Date()

        for date in sortedDates.reversed() {
            if calendar.isDate(date, inSameDayAs: currentDate) ||
               calendar.isDate(date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: currentDate)!) {
                streak += 1
                currentDate = date
            } else {
                break
            }
        }
        return streak - 1
    }

    private func bestStreak() -> Int {
        guard let dates = habit?.assignedDates, !dates.isEmpty else { return 0 }
        let calendar = Calendar.current
        let sortedDates = dates.sorted()
        var best = 1
        var current = 1

        for i in 1..<sortedDates.count {
            let diff = calendar.dateComponents(
                [.day],
                from: sortedDates[i-1],
                to: sortedDates[i]
            ).day ?? 0

            if diff == 1 {
                current += 1
                best = max(best, current)
            } else {
                current = 1
            }
        }
        return best
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView,
                                  numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }

    override func collectionView(_ collectionView: UICollectionView,
                                  cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CalendarDetailCell",
                for: indexPath
            ) as! CalendarDetailCell

            if let dates = habit?.assignedDates {
                cell.configure(with: dates)
            }
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "RecordCardCell",
                for: indexPath
            ) as! RecordCardCell

            switch indexPath.row {
            case 0:
                cell.configure(
                    icon: "calendar",
                    number: daysInCurrentMonth(),
                    description: "Days in Month"
                )
            case 1:
                cell.configure(
                    icon: "checkmark.circle.fill",
                    number: totalDaysDone(),
                    description: "Total Days Done"
                )
            case 2:
                cell.configure(
                    icon: "cube.fill",
                    number: currentStreak(),
                    description: "Current Streak"
                )
            case 3:
                cell.configure(
                    icon: "crown.fill",
                    number: bestStreak(),
                    description: "Best Streak"
                )
            default:
                break
            }
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                  viewForSupplementaryElementOfKind kind: String,
                                  at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "RecordsHeader",
            for: indexPath
        )

        header.subviews.forEach { $0.removeFromSuperview() }
        header.backgroundColor = .clear

        let label = UILabel()
        label.text = "Records"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])

        return header
    }
}
