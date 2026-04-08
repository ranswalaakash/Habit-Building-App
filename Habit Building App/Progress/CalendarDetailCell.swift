//
//  CalendarDetailCell.swift
//  Habit Harmony
//

import UIKit

class CalendarDetailCell: UICollectionViewCell,
                           UICalendarViewDelegate {

    @IBOutlet weak var calendarContainer: UIView!

    
    private var calendarView: UICalendarView!
    var completedDates: [Date] = [] {
        didSet {
            updateCalendarDecorations()
        }
    }

  
        override func awakeFromNib() {
            super.awakeFromNib()
            backgroundColor = .white
            layer.cornerRadius = 20
            clipsToBounds = true
            setupCalendar()
        }

    private func setupCalendar() {
        calendarView = UICalendarView()
        calendarView.delegate = self
        calendarView.calendar = Calendar.current
        calendarView.locale = Locale.current
        calendarView.fontDesign = .rounded
        calendarView.backgroundColor = .white
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        calendarContainer.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarContainer.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarContainer.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarContainer.trailingAnchor)
        ])
    }

    func configure(with dates: [Date]) {
        completedDates = dates
    }

    func calendarView(_ calendarView: UICalendarView,
                      decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let date = Calendar.current.date(from: dateComponents) else { return nil }

        let isCompleted = completedDates.contains { completedDate in
            Calendar.current.isDate(completedDate, inSameDayAs: date)
        }

        if isCompleted {
            return .default(
                color: UIColor(red: 0.35, green: 0.35, blue: 1.0, alpha: 1.0),
                size: .large
            )
        }

        return nil
    }

    private func updateCalendarDecorations() {
        guard calendarView != nil else { return }
        calendarView.reloadDecorations(
            forDateComponents: completedDates.map {
                Calendar.current.dateComponents([.year, .month, .day], from: $0)
            },
            animated: true
        )
    }
}
