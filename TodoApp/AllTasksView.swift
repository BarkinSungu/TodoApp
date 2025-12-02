import SwiftUI

struct AllTasksView: View {
    @Binding var tasks: [Task]
    let storage: TaskStorage
    var onTaskTap: (Task) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(getAllTasks(tasks: tasks)) { task in
                    Button {
                        onTaskTap(task)
                    } label: {
                        Text(task.title)
                    }
                }
            }
            .navigationTitle("Tüm Görevler")
        }
    }
    
    func getAllTasks(tasks: [Task]) -> [Task] {
        return tasks.filter { task in
            
            if (task.frequency == DateComponents(year: nil, month: nil, day: 0) && task.lastCompletedDate != nil){
                return false
            }
            return true
        }
    }
}
