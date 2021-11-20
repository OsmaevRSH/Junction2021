import UIKit

class MainViewController: UIViewController {
	@IBOutlet weak var taskTable: UITableView!
	@IBOutlet weak var userAvatar: UIImageView!
	@IBOutlet weak var addNewTaskButton: UIButton!
	let taskTableCellId = "taskTableCell"
	let httpService = HttpService()
	var searchResults: [TaskDataModel] = []
	let jsonService = JsonService()
	var taskDataset: [TaskDataModel]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FormatUserAvatar()
		FormatAddNewTaskButton()
		taskTable.delegate = self
		taskTable.dataSource = self
		taskTable.estimatedRowHeight = UITableView.automaticDimension
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		httpService.GetDataFromApi(url: "http://localhost:8082/get/tasks?name=pip")
		{
			data, response, error in
			if let data = data {
				if let temp = self.jsonService.DataToObj(data: data, type: TaskDataModel.self)
				{
					self.taskDataset = temp
					print(temp)
				}
				else if let error = error {
					print("HTTP Request Failed \(error)")
					}
				}
				DispatchQueue.main.async {
					self.taskTable.reloadData()
			}
		}
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
	}
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let temp = taskDataset else { return 0 }
		return temp.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: taskTableCellId, for: indexPath) as? TaskTableViewCell
		{
			if let localDataset = taskDataset {
				let item = localDataset[indexPath.row]
				cell.name.text = item.Name
				cell.name.sizeToFit()
				cell.task.text = item.Description
				cell.task.sizeToFit()
				cell.date.text = item.End_date
				cell.date.sizeToFit()
				return cell
			}
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
