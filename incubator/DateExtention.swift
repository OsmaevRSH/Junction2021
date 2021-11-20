import Foundation

extension Date {
	func asGMT(fromDate givenDate: String = "") -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		let dateString = givenDate.isEmpty ? formatter.string(from: self) : givenDate
		return formatter.date(from: dateString)
	}
}
