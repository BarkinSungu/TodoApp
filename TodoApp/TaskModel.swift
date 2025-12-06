import Foundation

struct Task: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var lastCompletedDate: Date?
    var frequency: DateComponents
    var duration: Int
    var nextTime: Date
    var totalTime: Int
    var totalDoneCount: Int
    var haveReminder: Bool
    var reminderTime: DateComponents?
    
    init(title: String, lastCompletedDate: Date?, frequency: DateComponents, duration: Int, nextTime: Date, totalTime: Int, totalDoneCount: Int, haveReminder: Bool = false, reminderTime: DateComponents? = nil) {
        self.id = UUID()
        self.title = title
        self.lastCompletedDate = lastCompletedDate
        self.frequency = frequency
        self.duration = duration
        self.nextTime = nextTime
        self.totalTime = totalTime
        self.totalDoneCount = totalDoneCount
        self.haveReminder = haveReminder
        self.reminderTime = reminderTime
    }
}

struct Frequency: Identifiable {
    let id = UUID()
    let title: String
    let dateComponents: DateComponents
    let isCustom: Bool
}

let presetFrequencies: [Frequency] = [
    .init(title: "Bir defa", dateComponents: DateComponents(day:0), isCustom: false),
    .init(title: "Her Gün", dateComponents: DateComponents(day:1), isCustom: false),
    .init(title: "İki Günde Bir", dateComponents: DateComponents(day:2), isCustom: false),
    .init(title: "Üç Günde Bir", dateComponents: DateComponents(day:3), isCustom: false),
    .init(title: "Haftada Bir", dateComponents: DateComponents(day:7), isCustom: false),
    .init(title: "iki Haftada Bir", dateComponents: DateComponents(day:14), isCustom: false),
    .init(title: "On Günde Bir", dateComponents: DateComponents(day:10), isCustom: false),
    .init(title: "Ayda Bir", dateComponents: DateComponents(month:1), isCustom: false),
    .init(title: "Yılda Bir", dateComponents: DateComponents(year:1), isCustom: false),
    .init(title: "Özel", dateComponents: DateComponents(day:0), isCustom: true),
]
