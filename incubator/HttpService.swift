import Foundation

class HttpService {
	var dataTask: URLSessionDataTask?
	let defaultSession = URLSession.shared
	let jsonDecoder = JsonService()
	
	var errorMessage = ""
	var tasks: [TaskDataModel] = []
	
	typealias JSONDictionary = [String: Any]
	typealias QueryResult = ([TaskDataModel]?, String) -> Void
	
	func GetDataFromApi(url: String) {
		
		let url = URL(string: url)!
		
		var request = URLRequest(url: url)
		
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let task = URLSession.shared.dataTask(with: url)
		{
			data, response, error in
			if let data = data {
				if let test = self.jsonDecoder.DataToObj(data: data, type: TaskDataModel.self)
				{
					for item in test {
						print(item.Name, item.Description, item.End_date, item.Start_date, item.User_name)
					}
				}
			} else if let error = error {
				print("HTTP Request Failed \(error)")
			}
		}
		task.resume()
	}
	
	func postRequest(url: String, data: String) {
		
		let url = URL(string: url)!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("\(String(describing: data.count))", forHTTPHeaderField: "Content-Length")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		print(data)
		request.httpBody = data.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			print(response.debugDescription)
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
				print(responseJSON)			}
		}
		task.resume()
	}
}
