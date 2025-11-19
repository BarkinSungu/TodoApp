import Foundation

struct Task: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var lastCompletedDate: Date?
    var frequency: Int
    var duration: Int

    init(title: String, lastCompletedDate: Date?, frequency: Int, duration: Int) {
        self.id = UUID()
        self.title = title
        self.lastCompletedDate = lastCompletedDate
        self.frequency = frequency
        self.duration = duration
    }
}
