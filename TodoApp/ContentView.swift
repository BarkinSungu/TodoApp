//
//  ContentView.swift
//  TodoApp
//
//  Created by Barkın Süngü on 24.08.2025.
//

import SwiftUI

struct ContentView: View {
    struct Task: Identifiable, Hashable {
        let id: UUID = UUID()             // Benzersiz kimlik
        var title: String                 // Görev başlığı
        var lastCompletedDate: Date?      // Son tamamlanma tarihi (opsiyonel)
        var frequency: String             // Örn: "Günlük", "Haftalık"
        var duration: Int                 // Süre (dakika cinsinden)
    }
    
    @State var tasks = [
        Task(title: "Swift öğren", lastCompletedDate: nil, frequency: "Günlük", duration: 60),
        Task(title: "Egzersiz yap", lastCompletedDate: Date(), frequency: "Haftalık", duration: 30),
        Task(title: "Kitap oku", lastCompletedDate: nil, frequency: "Günlük", duration: 45)
    ]
    @State var completedTasks = [
        Task(title: "Uyan", lastCompletedDate: nil, frequency: "Günlük", duration: 5)
    ]
//        @State var todos: [String] = ["Swift öğren", "SwiftUI ile uygulama yap"]
//        @State private var completedTodos: [String] = ["Uyan"]
    @State private var showAddTodoSheet = false

    
    var body: some View {
        NavigationStack {
            VStack {
                // Yeni yapılacak ekleme alanı
                HStack {
//                    TextField("Yeni yapılacak...", text: $newTodo)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
                    
                    Button(action: {
                        showAddTodoSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showAddTodoSheet) {
                        AddTaskSheetView{ newTask in
                            addTask(newTask)
                        }
                        .presentationDetents([.large]) // Yükseklik: ekranın %40'ı
                        .presentationDragIndicator(.visible)   // Üstte sürükleme çubuğu
                    }
                }
                .padding(.top)
                
                // Liste
                List {
                    ForEach(tasks, id: \.self) { task in
                        Text(task.title)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    completeTask(id: task.id)
                                } label: {
                                    Label("Tamamla", systemImage: "checkmark")
                                }
                                .tint(.green) // yeşil buton
                            }
                    }
                    ForEach(Array(completedTasks.enumerated()), id: \.element) { index, task in
                        Text(task.title)
                            .strikethrough(true, color: .gray)
                            .italic()
                            .foregroundColor(.gray)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    uncompleteTask(id: task.id)
                                } label: {
                                    Label("Geri Al", systemImage: "arrow.uturn.backward")
                                }
                                .tint(.blue)
                            }
                        }
                }
            }
//            .navigationTitle("📋 Yapılacaklar")
        }
    }
    
    // MARK: - Functions
    func addTask(_ newTaskTitle: String) {
//        guard !newTask.isEmpty else { return }
        let task = Task(title: newTaskTitle, lastCompletedDate: nil, frequency: "Günlük", duration: 60)
        tasks.append(task)
    }
    
    private func completeTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            let completed = tasks.remove(at: index)
            completedTasks.append(completed)
        }
    }
    
    private func uncompleteTask(id: UUID) {
        if let index = completedTasks.firstIndex(where: { $0.id == id }) {
            let uncompleted = completedTasks.remove(at: index)
            tasks.append(uncompleted)
        }
    }
}

struct AddTaskSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newTodo = ""
    var onAdd: (String) -> Void  // 👈 Closure tanımı

    var body: some View {
        VStack(spacing: 16) {
            Text("Yeni Görev Ekle")
                .font(.headline)

            TextField("Görev girin...", text: $newTodo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Ekle") {
                // Burada yeni todo ekleme işlemini yap
                onAdd(newTodo)

                dismiss() // Sheet’i kapat
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
