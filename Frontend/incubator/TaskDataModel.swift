import Foundation


struct TaskDataModel: Codable {
	let Name: String
	let End_date: String
	let Description: String
	let Start_date: String
	let User_name: String?
	
	private enum CodingKeys: String, CodingKey {
		case Name, End_date, Description, Start_date, User_name
	}
}
