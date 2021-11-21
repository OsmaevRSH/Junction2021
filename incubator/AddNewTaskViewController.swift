import UIKit

class AddNewTaskViewController: UIViewController {
	
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var taskDescription: UITextView!
	@IBOutlet weak var calendar: UIDatePicker!
	@IBOutlet weak var task: UITextField!
	let defaults = UserDefaults.standard
	var localUserName: String?
	
	let httpService = HttpService()
	let jsonService = JsonService()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let login = defaults.string(forKey: "localUserName") {
			localUserName = login
		}
		FormatSubmitButton()
		FormatUITextView()
	}
	
	@IBAction func submitButtonHandler(_ sender: UIButton) {
		let date = Date()
		let df = DateFormatter()
		df.timeZone = TimeZone(secondsFromGMT:0)
		df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
		let dateString = df.string(from: date)
		
		let taskData = TaskDataModel(Name: task.text ?? "randomTask",
									 End_date: calendar.date.description,
									 Description: taskDescription.text,
									 Start_date: dateString,
									 User_name: localUserName!) //TODO userName
		
		if let json = jsonService.ObjToJson(taskData) {
			httpService.PostRequest(url: "http://localhost:8082/create/task", data: json)
		}
	}
	
	func FormatSubmitButton()
	{
		submitButton.layer.cornerRadius = 0.04 * submitButton.bounds.size.width
		submitButton.clipsToBounds = true
	}
	
	func FormatUITextView()
	{
		taskDescription.layer.cornerRadius = 0.02 * taskDescription.bounds.size.width
		taskDescription.clipsToBounds = true
		taskDescription.layer.borderColor = UIColor.systemGray4.cgColor
		taskDescription.layer.borderWidth = 0.3
	}
	
}
