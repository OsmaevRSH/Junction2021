import UIKit

class TaskTableViewCell: UITableViewCell {
	
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var task: UILabel!
	@IBOutlet weak var date: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		task.lineBreakMode = .byWordWrapping
		task.numberOfLines = 0
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
