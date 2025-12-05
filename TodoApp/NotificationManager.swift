import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification auth error: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func clearAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
    
    // Helpers
    func date(atHour hour: Int, minute: Int, on base: Date = Date()) -> Date? {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: base)
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: start)
    }
    
    func scheduleNotifications(title: String, body: String, dates: [Date]) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        
        for date in dates {
            //            print("Schedule Notifications: Title: \(title), Body: \(body), date: \(date)")
            let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(req) { error in
                if let error = error { print("Add notification error: \(error)") }
            }
        }
    }
    
    func getNotificationsFromNotificationsCenter() {
        print("get notifications çağırıldı ---------------------------")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for req in requests {
                if let trigger = req.trigger as? UNCalendarNotificationTrigger,
                   let date = trigger.nextTriggerDate() {
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    
                    print("⏰ \(formatter.string(from: date))")
                }
            }
        }
    }
    
    func scheduleMorningNotifications(for dates: [Date], title: String, bodyForCount: (Int) -> String, pendingCountForDate: (Date) -> Int) {
        let calendar = Calendar.current
        let now = Date()
        for date in dates {
            // Build 09:00 of that date
            guard let nine = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: calendar.startOfDay(for: date)) else { continue }
            guard nine > now else { continue }
            let count = pendingCountForDate(date)
            guard count > 0 else { continue }
            let body = bodyForCount(count)
            scheduleNotifications(title: title, body: body, dates: [nine])
        }
    }
    
    func nextDays(count: Int) -> [Date] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        return (0..<count).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }
       
    private func todaysPendingTasks(_ tasks:[Task]) -> [Task] {
        let today = todayDateOnly()
        return tasks.filter { task in
            let lastCompletedDate = task.lastCompletedDate
            let nextTime = task.nextTime
            let frequency = task.frequency
            let isOneTime = frequency.year == nil && frequency.month == nil && frequency.day == 0
            
            if lastCompletedDate == today { return false }
            if nextTime == today { return true }
            if nextTime < today {
                if isOneTime { return lastCompletedDate == nil }
                return true
            }
            return false
        }
    }
    
    private func pendingTasks(on date: Date,_ tasks:[Task]) -> [Task] {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)
        return tasks.filter { task in
            let lastCompletedDate = task.lastCompletedDate
            let nextTime = task.nextTime
            let frequency = task.frequency
            let isOneTime = frequency.year == nil && frequency.month == nil && frequency.day == 0
            
            if lastCompletedDate == day { return false }
            if nextTime == day { return true }
            if nextTime < day {
                if isOneTime { return lastCompletedDate == nil }
                return true
            }
            return false
        }
    }
    
    private func todayDateOnly() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components)!
    }
    
    func scheduleNotifications(_ tasks:[Task]){
        NotificationManager.shared.clearAllNotifications()
        scheduleNotificationsForToday(tasks)
        scheduleNextMorningNotifications(tasks)
//        NotificationManager.shared.getNotificationsFromNotificationsCenter()
    }
    
    func scheduleNotificationsForToday(_ tasks:[Task]) {
        NotificationManager.shared.requestAuthorization()
        
        let pending = todaysPendingTasks(tasks)
        guard !pending.isEmpty else {
            return
        }
        
        // Build schedule: 09:00 plus offsets (3h, 6h, 9h, ...) from now, capped at 23:00
        var dates: [Date] = []
        if let nine = NotificationManager.shared.date(atHour: 9, minute: 0) {
            // If it's still in the future, include it
            if nine > Date() { dates.append(nine) }
        }
        
        let now = Date()
        let calendar = Calendar.current
        let endOfDay = calendar.date(bySettingHour: 23, minute: 0, second: 0, of: todayDateOnly())!
        
        var offsetHours = 3
        while true {
            if let next = calendar.date(byAdding: .hour, value: offsetHours, to: now) {
                if next <= endOfDay {
                    dates.append(next)
                    offsetHours += 3
                    continue
                }
            }
            break
        }
        
        let count = pending.count
        let title = "Yapılacak Görevler"
        let body = count == 1 ? "Bugün 1 görevin var. Hadi tamamla!" : "Bugün \(count) görevin var. Hadi tamamla!"
        
        NotificationManager.shared.scheduleNotifications(title: title, body: body, dates: dates)
    }
    
    func scheduleNextMorningNotifications(_ tasks:[Task]) {
        // nextDays(count:) bugünden başlatıyor; biz yarından başlatalım:
        let all = NotificationManager.shared.nextDays(count: 30) // bugün + 30 gün
        let dates = Array(all.dropFirst()) // yarından itibaren 30 gün
        
        let title = "Yapılacak Görevler"
        let bodyForCount: (Int) -> String = { count in
            count == 1 ? "Bugün 1 görevin var. Hadi tamamla!" : "Bugün \(count) görevin var. Hadi tamamla!"
        }
        let pendingCountForDate: (Date) -> Int = { date in
            return self.pendingTasks(on: date, tasks).count
        }
        
        NotificationManager.shared.scheduleMorningNotifications(
            for: dates,
            title: title,
            bodyForCount: bodyForCount,
            pendingCountForDate: pendingCountForDate
        )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
