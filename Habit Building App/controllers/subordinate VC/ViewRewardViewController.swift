//
//  ViewReward.swift
//  reward Cells
//
//  Created by Aakash Singh Ranswal on 16/03/26.
//

import UIKit

class ViewReward: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rewardTitleLabel: UILabel!

    var reward: Reward?
    var entries: [RewardEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        rewardTitleLabel.text = reward?.name

        if let reward = reward {
            entries = RewardDataModel.shared.getEntries(for: reward.id)
        }

        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func addEntryTapped(_ sender: UIBarButtonItem) {

        guard let reward = reward else { return }

        let vc = storyboard?.instantiateViewController(
            withIdentifier: "AddRewardViewController"
        ) as! AddRewardVC

        vc.reward = reward

        vc.onSave = { [weak self] date in
            guard let self = self else { return }

            RewardDataModel.shared.addEntry(
                to: reward.id,
                title: reward.name,
                date: date
            )

            DispatchQueue.main.async {
                self.entries = RewardDataModel.shared.getEntries(for: reward.id)
                self.tableView.reloadData()
            }
        }

        present(vc, animated: true)
    }
}

extension ViewReward: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "entry_cell",
            for: indexPath
        )

        let entry = entries[indexPath.row]

        let dateLabel = cell.viewWithTag(1) as! UILabel
        let statusLabel = cell.viewWithTag(2) as! UILabel

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        dateLabel.text = formatter.string(from: entry.date)
        statusLabel.text = "Redeemed"

        return cell
    }
}

extension ViewReward: UITableViewDelegate {

}
