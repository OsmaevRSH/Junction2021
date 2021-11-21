import Foundation

struct User: Codable {
	let name: String
	let xp: Float
	
	private enum CodingKeys: String, CodingKey {
		case name, xp
	}
}
