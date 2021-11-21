import UIKit

class CreateAccountViewController: UIViewController {

	@IBOutlet weak var userLogin: UITextField!
	@IBOutlet weak var createButton: UIButton!
	let httpService = HttpService()
	let jsonService = JsonService()
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func CreateButtonAction(_ sender: UIButton) {
		let defaults = UserDefaults.standard
		if let user = userLogin.text {
			if !user.isEmpty {
				defaults.set(user, forKey: "localUserName")
				let temp = User(name: user, xp: 0)
				if let json = jsonService.ObjToJson(temp) {
					httpService.PostRequest(url: "http://localhost:8080/user/add", data: json)
				}
			}
		}
	}
}
