import SwiftUI

struct AllTasksView: View {
    @Binding var tasks: [Task]
    let storage: TaskStorage

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    Text(task.title)
                }
            }
            .navigationTitle("Tüm Görevler")
        }
    }
}
