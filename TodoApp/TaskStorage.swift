import Foundation

class TaskStorage {
    private let tasksKey = "tasks_key"
    private let completedTasksKey = "completed_tasks_key"
    
    // Görevleri kaydet
    func saveTasks(_ tasks: [Task]) {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }
    
    // Görevleri yükle
    func loadTasks() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            return decoded
        }
        return []
    }
    
}
