import Foundation

struct Task: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var lastCompletedDate: Date?
    var frequency: Int
    var duration: Int
    var nextTime: Date
    var totalTime: Int
    var totalDoneCount: Int

    init(title: String, lastCompletedDate: Date?, frequency: Int, duration: Int, nextTime: Date, totalTime: Int, totalDoneCount: Int) {
        self.id = UUID()
        self.title = title
        self.lastCompletedDate = lastCompletedDate
        self.frequency = frequency
        self.duration = duration
        self.nextTime = nextTime
        self.totalTime = totalTime
        self.totalDoneCount = totalDoneCount
    }
}
