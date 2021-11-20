import Foundation

class JsonService {
	let dateFormatter = DateFormatter()
	let decoder = JSONDecoder()
	
	init() {
		dateFormatter.calendar = Calendar(identifier: .iso8601)
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
	}
	
	func ObjToJson<T: Codable>(_ obj: T) -> String? {
		let jsonEncoder = JSONEncoder()
		let jsonData = try! jsonEncoder.encode(obj)
		let json = String(data: jsonData, encoding: String.Encoding.utf8)
		return json
	}
	
	func DataToObj<T: Codable>(data: Data, type: T.Type) -> [T]? {
		do {
			let books = try decoder.decode([T].self, from: data)
			return books
		}
		catch {
			print(error)
		}
		return nil
	}
}
