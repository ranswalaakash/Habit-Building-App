//
//  CollaborativeActivityStepsViewController.swift
//  Habit Harmony
//
//  Created by GEU on 07/02/26.
//

import UIKit

class CollaborativeActivityStepsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerDescriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

   
    
    var activity: CollaborativeActivityList?
    private var steps: [CollaborativeActivitySteps] = []
    private var expandedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        headerTitleLabel.text = activity?.title
        headerDescriptionLabel.text = activity?.description

        steps = activity?.steps ?? []

        configureTable()
        configureButton()
        
        actionButton.setTitle("Start Guide", for: .normal)
        actionButton.layer.cornerRadius = 18
        actionButton.clipsToBounds = true
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }

    private func configureButton() {
        actionButton.layer.cornerRadius = 16
        actionButton.clipsToBounds = true
    }
}

extension CollaborativeActivityStepsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        steps.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "step_cell",
            for: indexPath
        ) as! CollaborativeActivityStepCell

        let isExpanded = expandedIndex == indexPath.row

        cell.configure(
            with: steps[indexPath.row],
            isExpanded: isExpanded
        )

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if expandedIndex == indexPath.row {
            expandedIndex = nil
        } else {
            expandedIndex = indexPath.row
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {

        let next = (expandedIndex ?? -1) + 1

            if next < steps.count {
                expandedIndex = next
                tableView.reloadData()

                tableView.scrollToRow(
                    at: IndexPath(row: next, section: 0),
                    at: .middle,
                    animated: true
                )
            } else {
                print("Capture Activity Moment")
            }

            updateButtonTitle()
    }
    
    func updateButtonTitle() {

        if expandedIndex == nil {
            actionButton.setTitle("Start Guide", for: .normal)
        }
        else if expandedIndex == steps.count - 1 {
            actionButton.setTitle("Capture Activity Moment", for: .normal)
        }
        else {
            actionButton.setTitle("Next Step", for: .normal)
        }
    }
}
