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

    private let storage = TaskStorage()

    var body: some View {
        VStack(spacing: 0) {

            // --- SAYFALAR ---
            if selectedTab == 0 {
                TodayView(tasks: $tasks, storage: storage)
            } else {
                AllTasksView(tasks: $tasks, storage: storage)
            }

            // --- ALT BAR ---
            BottomBar(
                selectedTab: $selectedTab,
                showAddSheet: $showAddSheet
            )
        }
        .sheet(isPresented: $showAddSheet) {
            AddTaskSheetView { title in
                let newTask = Task(title: title, lastCompletedDate: nil, frequency: 1, duration: 60)
                tasks.append(newTask)
                storage.saveTasks(tasks)
            }
        }
        .onAppear {
            tasks = storage.loadTasks()
        }
    }
}
