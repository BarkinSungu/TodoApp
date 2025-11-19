//
//  TodayView.swift
//  TodoApp
//
//  Created by Barkın Süngü on 18.11.2025.
//

import SwiftUI

struct TodayView: View {
    @Binding var tasks: [Task]
    @Binding var completedTasks: [Task]
    let storage: TaskStorage

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
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

                ForEach(completedTasks) { task in
                    Text(task.title)
                        .strikethrough()
                        .foregroundColor(.gray)
                        .italic()
                        .swipeActions {
                            Button {
                                uncompleteTask(id: task.id)
                            } label: {
                                Label("Geri Al", systemImage: "arrow.uturn.backward")
                            }
                            .tint(.blue)
                        }
                }
            }
            .navigationTitle("Bugün")
        }
    }

    private func completeTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            let t = tasks.remove(at: index)
            completedTasks.append(t)
            storage.saveTasks(tasks)
            storage.saveCompletedTasks(completedTasks)
        }
    }

    private func uncompleteTask(id: UUID) {
        if let index = completedTasks.firstIndex(where: { $0.id == id }) {
            let t = completedTasks.remove(at: index)
            tasks.append(t)
            storage.saveTasks(tasks)
            storage.saveCompletedTasks(completedTasks)
        }
    }
}
