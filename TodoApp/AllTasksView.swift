import SwiftUI

struct AllTasksView: View {
    @Binding var tasks: [Task]
    @Binding var completedTasks: [Task]
    let storage: TaskStorage

    var body: some View {
        NavigationStack {
            List {
                Section("Tamamlanmamış") {
                    ForEach(tasks) { task in
                        Text(task.title)
                    }
                }

                Section("Tamamlananlar") {
                    ForEach(completedTasks) { task in
                        Text(task.title)
                            .strikethrough()
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
            }
            .navigationTitle("Tüm Görevler")
        }
    }
}
