//
//  ContentView.swift
//  TodoApp
//
//  Created by Barkın Süngü on 24.08.2025.
//

import SwiftUI

struct ContentView: View {
        @State var todos: [String] = ["Swift öğren", "SwiftUI ile uygulama yap"]
    //    @State private var newTodo: String = ""
        @State private var completedTodos: [String] = ["Uyan"]
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
                        AddTodoSheetView{ newTodo in
                            addTodo(newTodo)
                        }
                        .presentationDetents([.large]) // Yükseklik: ekranın %40'ı
                        .presentationDragIndicator(.visible)   // Üstte sürükleme çubuğu
                    }
                }
                .padding(.top)
                
                // Liste
                List {
                    ForEach(todos, id: \.self) { todo in
                        Text(todo)
                    }
                    .onDelete(perform: deleteTodo)
                    ForEach(Array(completedTodos.enumerated()), id: \.element) { index, todo in
                            Text(todo)
                                .strikethrough(true, color: .gray)
                                .italic()
                                .foregroundColor(.gray)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button("Geri Al") {
                                        reAddTodo(at: IndexSet(integer: index))
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
    func addTodo(_ newTodo: String) {
        guard !newTodo.isEmpty else { return }
        todos.append(newTodo)
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let completedTodo = todos[index]
            completedTodos.append(completedTodo)
        }
        todos.remove(atOffsets: offsets)
    }
    
    private func reAddTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = completedTodos[index]
            todos.append(todo)
        }
        completedTodos.remove(atOffsets: offsets)
    }
}

struct AddTodoSheetView: View {
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
