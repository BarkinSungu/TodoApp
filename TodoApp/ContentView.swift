import SwiftUI

enum Tab {
    case today
    case all
}

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showAddSheet = false

    @State private var tasks: [Task] = []
    @State private var completedTasks: [Task] = []
    
    @State private var selectedTask: Task? = nil
    @State private var showTaskDetailSheet = false

    private let storage = TaskStorage()

    var body: some View {
        VStack(spacing: 0) {

            // --- SAYFALAR ---
            if selectedTab == 0 {
                TodayView(tasks: $tasks, storage: storage)
            } else {
                AllTasksView(tasks: $tasks, storage: storage, onTaskTap: { task in
                    selectedTask = task})
                .sheet(item: $selectedTask) {
                    task in
                        TaskDetailSheetView(
                            task: task,
                            onDelete: { task in
                                deleteTask(task)
                            }, onSave: { updatedTask in
                                updateTask(updatedTask)
                            }
                        )
                }
            }

            // --- ALT BAR ---
            BottomBar(
                selectedTab: $selectedTab,
                showAddSheet: $showAddSheet
            )
        }
        .sheet(isPresented: $showAddSheet) {
            AddTaskSheetView { title, frequency in
                let newTask = Task(title: title, lastCompletedDate: nil, frequency: frequency, duration: 60)
                tasks.append(newTask)
                storage.saveTasks(tasks)
            }
        }
        .onAppear {
            tasks = storage.loadTasks()
            print(tasks)
        }
    }
    
    func updateTask(_ updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
            storage.saveTasks(tasks)
        }
    }
    
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            storage.saveTasks(tasks)
        }
    }
}

extension Date {
    func asDayMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"   // GÜN.AY.YIL
        return formatter.string(from: self)
    }
}
