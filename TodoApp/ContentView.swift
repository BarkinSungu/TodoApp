import SwiftUI
import UserNotifications

enum Tab {
    case today
    case all
}

struct ContentView: View {
    init() {
        UIDatePicker.appearance().tintColor = UIColor(AppColors.primaryText)     // seçici rengini
        UILabel.appearance(whenContainedInInstancesOf: [UIDatePicker.self]).textColor = UIColor(AppColors.primaryText) // yazı rengini
    }
    
    @State private var selectedTab = 0
    @State private var showAddSheet = false
    
    @State private var tasks: [Task] = []
    @State private var completedTasks: [Task] = []
    
    @State private var selectedTask: Task? = nil
    @State private var showTaskDetailSheet = false
    @State private var viewId = UUID()
    
    @Environment(\.scenePhase) private var scenePhase
    
    private let storage = TaskStorage()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // --- SAYFALAR ---
            if selectedTab == 0 {
                TodayView(tasks: $tasks, storage: storage).id(viewId)
            } else {
                AllTasksView(tasks: $tasks, storage: storage, onTaskTap: { task in
                    selectedTask = task})
                .sheet(item: $selectedTask) {
                    task in
                    TaskDetailSheetView(
                        task: task,
                        onDelete: { task in
                            deleteTask(task)
                            refresh()
                        }, onSave: { updatedTask in
                            updateTask(updatedTask)
                            refresh()
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
            AddTaskSheetView { title, duration, frequency, nextTime in
                let newTask = Task(title: title, lastCompletedDate: nil, frequency: frequency, duration: duration, nextTime: nextTime, totalTime: 0, totalDoneCount: 0)
                tasks.append(newTask)
                storage.saveTasks(tasks)
                refresh()
            }
        }
        .onAppear {
            tasks = storage.loadTasks()
            //            print(tasks)
            NotificationManager.shared.scheduleNotifications(tasks)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                refresh()
            }
        }
    }
    
    func updateTask(_ updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
            storage.saveTasks(tasks)
            NotificationManager.shared.scheduleNotifications(tasks)
        }
    }
    
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            storage.saveTasks(tasks)
            NotificationManager.shared.scheduleNotifications(tasks)
        }
    }
    
    private func refresh() {
        tasks = storage.loadTasks()
        viewId = UUID()
        //        print(tasks)
        NotificationManager.shared.scheduleNotifications(tasks)
    }
}

extension Date {
    func asDayMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
