//
//  ContentView.swift
//  TodoApp
//
//  Created by Barkın Süngü on 24.08.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [String] = ["Swift öğren", "SwiftUI ile uygulama yap"]
    @State private var newTodo: String = ""
    @State private var completedTodos: [String] = ["Uyan"]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Yeni yapılacak ekleme alanı
                HStack {
                    TextField("Yeni yapılacak...", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: addTodo) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
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
    private func addTodo() {
        guard !newTodo.isEmpty else { return }
        todos.append(newTodo)
        newTodo = ""
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

#Preview {
    ContentView()
}
