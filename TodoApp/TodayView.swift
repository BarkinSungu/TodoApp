import SwiftUI

struct TodayView: View {
    @Binding var tasks: [Task]
    let storage: TaskStorage
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(getTodaysTasks(tasks: tasks)) { task in
                    HStack{
                        Text(task.title)
                        Spacer()
                        Text("\(task.duration) dk")
                            .foregroundColor(.gray)
                    }
                    
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
                }
            }
            .navigationTitle("Bugün")
        }
    }
    
    private func completeTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].lastCompletedDate = todayDateOnly()
            tasks[index].nextTime = Calendar.current.date(byAdding: tasks[index].frequency, to: todayDateOnly())!
            tasks[index].totalTime = tasks[index].totalTime + tasks[index].duration
            tasks[index].totalDoneCount = tasks[index].totalDoneCount + 1
            storage.saveTasks(tasks)
            print(tasks)
        }
    }
    
    public func todayDateOnly() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components)!   // sadece yıl-ay-gün
    }
    
    func getTodaysTasks(tasks: [Task]) -> [Task]{
        let today = todayDateOnly()
        
        return tasks.filter { task in
            let lastCompletedDate = task.lastCompletedDate
            let nextTime = task.nextTime
            let frequency = task.frequency
            let isOneTime = frequency.year == nil && frequency.month == nil && frequency.day == 0
            
            if lastCompletedDate == today {
                return false
            }
            
            if nextTime == today {
                return true
            }
            
            if nextTime < today {
                if isOneTime{
                    if lastCompletedDate != nil{
                        return false
                    }else{
                        return true
                    }
                }else{
                    return true
                }
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

