import UIKit

class AddNewTaskViewController: UIViewController {
	
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var taskDescription: UITextView!
	@IBOutlet weak var calendar: UIDatePicker!
	@IBOutlet weak var task: UITextField!
	
	let httpService = HttpService()
	let jsonService = JsonService()
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
									 User_name: "pip") //TODO userName
		
		if let json = jsonService.ObjToJson(taskData) {
			httpService.postRequest(url: "http://localhost:8082/create/task", data: json)
		}
//		usleep(100000)
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
