import UIKit

class MainViewController: UIViewController {
	@IBOutlet weak var taskTable: UITableView!
	@IBOutlet weak var userAvatar: UIImageView!
	@IBOutlet weak var addNewTaskButton: UIButton!
	let taskTableCellId = "taskTableCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FormatUserAvatar()
		FormatAddNewTaskButton()
		taskTable.delegate = self
		taskTable.dataSource = self
		taskTable.estimatedRowHeight = UITableView.automaticDimension
	}
	
	func FormatUserAvatar()
	{
		userAvatar.image = UIImage(named: "AppIcon")
		userAvatar.makeRounded()
	}
	
	func FormatAddNewTaskButton()
	{
		addNewTaskButton.layer.cornerRadius = 0.5 * addNewTaskButton.bounds.size.width
		addNewTaskButton.clipsToBounds = true
	}
	
	@IBAction func unwind (_ seg: UIStoryboardSegue) {
		print("close 21312321312312")
	}
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: taskTableCellId, for: indexPath) as? TaskTableViewCell
		{
			cell.Name.text = "Start"
			cell.Name.sizeToFit()
			cell.Task.text = "WenderCast displays a list of raywenderlich.com podcasts and lets users play them. But it doesn’t let users know when a new podcast is available and the News tab is empty! You’ll soon fix these issues with the power of push notifications."
			cell.Task.sizeToFit()
			cell.Date.text = "22.12.2012"
			cell.Date.sizeToFit()
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let endTask = UIContextualAction(style: .normal,
										 title: "End Task") { [weak self] (action, view, completionHandler) in
			self?.handleEndTask()
			completionHandler(true)
		}
		endTask.backgroundColor = .systemGreen
		
		let giveUp = UIContextualAction(style: .destructive,
										title: "Give up") { [weak self] (action, view, completionHandler) in
			self?.handleGiveUp()
			completionHandler(true)
		}
		giveUp.backgroundColor = .systemRed
		
		let configuration = UISwipeActionsConfiguration(actions: [endTask, giveUp])
		
		return configuration
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .none
	}
	
	private func handleEndTask() {
		print("handleEndTask")
	}
	
	private func handleGiveUp() {
		print("handleGiveUp")
	}
}
