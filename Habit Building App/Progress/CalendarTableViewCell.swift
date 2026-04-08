//
//  CalendarTableViewCell.swift
//  Habit Harmony
//

import UIKit

class CalendarTableViewCell: UITableViewCell,
                              UICalendarViewDelegate,
                              UICalendarSelectionSingleDateDelegate {

    @IBOutlet weak var calendarContainer: UIView!

    var onDateSelected: ((Date) -> Void)?
    private var calendarView: UICalendarView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupCalendar()
    }

    private func setupCalendar() {
        calendarView = UICalendarView()
        calendarView.delegate = self
        calendarView.calendar = Calendar.current
        calendarView.locale = Locale.current
        calendarView.fontDesign = .rounded
        calendarView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 1.0, alpha: 1.0)
        calendarView.layer.cornerRadius = 16
        calendarView.clipsToBounds = true
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        let selection = UICalendarSelectionSingleDate(delegate: self)
        selection.selectedDate = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: Date()
        )
        calendarView.selectionBehavior = selection

        calendarContainer.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarContainer.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarContainer.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarContainer.trailingAnchor)
        ])
    }

    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        guard let dateComponents,
              let date = Calendar.current.date(from: dateComponents) else { return }
        onDateSelected?(date)
    }
}
