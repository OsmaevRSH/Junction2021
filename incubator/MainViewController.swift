import UIKit

class MainViewController: UIViewController {
	@IBOutlet weak var taskTable: UITableView!
	@IBOutlet weak var userAvatar: UIImageView!
	@IBOutlet weak var addNewTaskButton: UIButton!
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var levelBar: UIProgressView!
	@IBOutlet weak var userLevel: UILabel!
	let defaults = UserDefaults.standard
	let taskTableCellId = "taskTableCell"
	let httpService = HttpService()
	let jsonService = JsonService()
	var taskDataset: [TaskDataModel]?
	var localUserName: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let login = defaults.string(forKey: "localUserName") {
			localUserName = login
		}
		FormatUserAvatar()
		FormatAddNewTaskButton()
		taskTable.delegate = self
		taskTable.dataSource = self
		taskTable.estimatedRowHeight = UITableView.automaticDimension
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateTasks()
		updateUser()
	}
	
	func updateUserLevel(level: Float)
	{
		self.userLevel.text = String(level)
		self.levelBar.progress = Float(level.truncatingRemainder(dividingBy: 1))
	}
	
	func updateUser() {
		httpService.GetRequest(url: "http://localhost:8080/user/\(String(describing: localUserName!))") {
			data, response, error in
			if let data = data {
				print(String(data: data, encoding: .utf8))
				if let temp = self.jsonService.DataToObj(data: data, type: User.self)
				{
					DispatchQueue.main.async {
						self.userName.text = temp.name
						self.updateUserLevel(level: temp.xp / 500.0)
					}
				}
				else if let error = error {
					print("HTTP Request Failed \(error)")
				}
			}
		}
	}
	
	func updateTasks() {
		print("http://localhost:8082/get/tasks?name=\(String(describing: localUserName!))")
		httpService.GetRequest(url: "http://localhost:8082/get/tasks?name=\(String(describing: localUserName!))") {
			data, response, error in
			if let data = data {
				print(String(data: data, encoding: .utf8))
				if let temp = self.jsonService.DataToObj(data: data, type: [TaskDataModel].self) {
					self.taskDataset = temp
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
				let tmp = item.End_date.split(separator: " ").map { String($0) }
				cell.date.text = tmp[0]
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
			if let localDataset = self?.taskDataset {
				let task = localDataset[indexPath.row]
				self?.handleEndTask(taskName: task.Name)
			}
			
			completionHandler(true)
		}
		endTask.backgroundColor = .systemGreen
		
		let giveUp = UIContextualAction(style: .destructive,
										title: "Give up") { [weak self] (action, view, completionHandler) in
			if let localDataset = self?.taskDataset {
				let task = localDataset[indexPath.row]
				self?.handleGiveUp(taskName: task.Name)
			}
			completionHandler(true)
		}
		giveUp.backgroundColor = .systemRed
		
		let configuration = UISwipeActionsConfiguration(actions: [endTask, giveUp])
		
		return configuration
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .none
	}
	
	private func handleEndTask(taskName: String) {
		let task = FinishTaskModel(Name: taskName, User_name: localUserName!)
		let json = jsonService.ObjToJson(task)!
		httpService.PostRequest(url: "http://localhost:8082/delete/task/finished", data: json)
		updateTasks()
		updateUser()
		print("handleEndTask")
	}
	
	private func handleGiveUp(taskName: String) {
		let task = FinishTaskModel(Name: taskName, User_name: localUserName!)
		let json = jsonService.ObjToJson(task)!
		httpService.PostRequest(url: "http://localhost:8082/delete/task/giveup", data: json)
		updateTasks()
		print("handleGiveUp")
	}
}
