import UIKit

class AddNewTaskViewController: UIViewController {
	
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var TaskDescription: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FormatSubmitButton()
		FormatUITextView()
	}
	
	@IBAction func submitButtonHandler(_ sender: UIButton) {
	}
	
	func FormatSubmitButton()
	{
		submitButton.layer.cornerRadius = 0.04 * submitButton.bounds.size.width
		submitButton.clipsToBounds = true
	}
	
	func FormatUITextView()
	{
		TaskDescription.layer.cornerRadius = 0.02 * TaskDescription.bounds.size.width
		TaskDescription.clipsToBounds = true
		TaskDescription.layer.borderColor = UIColor.systemGray4.cgColor
		TaskDescription.layer.borderWidth = 0.3
	}
	
}
