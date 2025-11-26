import SwiftUI

struct TodayView: View {
    @Binding var tasks: [Task]
    let storage: TaskStorage

    var body: some View {
        NavigationStack {
            List {
                ForEach(getTodaysTasks(tasks: tasks)) { task in
                    Text(task.title)
                        .swipeActions {
                            Button {
                                completeTask(id: task.id)
                            } label: {
                                Label("Tamamla", systemImage: "checkmark")
                            }
                            .tint(.green)
                        }
                }

                ForEach(getCompletedTasks(tasks: tasks)) { task in
                    Text(task.title)
                        .strikethrough()
                        .foregroundColor(.gray)
                        .italic()
//                        .swipeActions {
//                            Button {
//                                uncompleteTask(id: task.id)
//                            } label: {
//                                Label("Geri Al", systemImage: "arrow.uturn.backward")
//                            }
//                            .tint(.blue)
//                        }
                }
            }
            .navigationTitle("Bugün")
        }
    }

    private func completeTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].lastCompletedDate = todayDateOnly()
            tasks[index].nextTime = Calendar.current.date(byAdding: .day, value: tasks[index].frequency, to: todayDateOnly())!
            storage.saveTasks(tasks)
            print(tasks)
        }
    }

//    private func uncompleteTask(id: UUID) {
//        if let index = completedTasks.firstIndex(where: { $0.id == id }) {
//            let t = completedTasks.remove(at: index)
//            tasks.append(t)
//            storage.saveTasks(tasks)
//            storage.saveCompletedTasks(completedTasks)
//        }
//    }
    
    func todayDateOnly() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components)!   // sadece yıl-ay-gün
    }
    
    func getTodaysTasks(tasks: [Task]) -> [Task]{
        let today = todayDateOnly()
        
        return tasks.filter { task in
            let lastCompletedDate = task.lastCompletedDate
            let nextTime = task.nextTime

            if lastCompletedDate == today {
                return false
            }

            if nextTime == today {
                return true
            }

            if nextTime < today {
                return true
            }

            return false
        }
    }
    
    func getCompletedTasks(tasks: [Task]) -> [Task]{
        let today = todayDateOnly()
        
        return tasks.filter { task in

            if (task.lastCompletedDate == today){
                return true
            }
            return false
        }
    }
    
}
