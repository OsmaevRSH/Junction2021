import Foundation

class HttpService {
	var dataTask: URLSessionDataTask?
	
	var errorMessage = ""
	var tasks: [TaskDataModel] = []
	
	typealias JSONDictionary = [String: Any]
	typealias QueryResult = ([TaskDataModel]?, String) -> Void
	
	func GetRequest(url: String, handler: @escaping (Data?, URLResponse?, Error?) -> Void)  {
		let url = URL(string: url)!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		let task = URLSession.shared.dataTask(with: url, completionHandler: handler)
		task.resume()
	}
	
	func PostRequest(url: String, data: String) {
		
		let url = URL(string: url)!
		var request = URLRequest(url: url)
		let lock = DispatchSemaphore(value: 0)
		request.httpMethod = "POST"
		request.setValue("\(String(describing: data.count))", forHTTPHeaderField: "Content-Length")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = data.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
				print(responseJSON)
			}
			lock.signal()
		}
		task.resume()
		lock.wait()
	}
	
	func DeleteRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
		var components = URLComponents(string: url)!
		components.queryItems = parameters.map { (key, value) in
			URLQueryItem(name: key, value: value)
		}
		components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
		var request = URLRequest(url: components.url!)
		request.httpMethod = "DELETE"
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
				print(responseJSON)
			}
		}
		task.resume()
	}
}
