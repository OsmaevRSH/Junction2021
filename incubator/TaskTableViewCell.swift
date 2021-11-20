import UIKit

class TaskTableViewCell: UITableViewCell {
	
	@IBOutlet weak var Name: UILabel!
	@IBOutlet weak var Task: UILabel!
	@IBOutlet weak var Date: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		Task.lineBreakMode = .byWordWrapping
		Task.numberOfLines = 0
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
}
