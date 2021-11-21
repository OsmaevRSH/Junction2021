import Foundation

struct FinishTaskModel: Codable {
	let Name: String
	let User_name: String
	
	private enum CodingKeys: String, CodingKey {
		case Name, User_name
	}
}
