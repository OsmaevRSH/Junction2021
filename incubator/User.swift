import Foundation

struct User: Codable {
	let name: String
	let rating: Int
	
	private enum CodingKeys: String, CodingKey {
		case name, rating
	}
}
