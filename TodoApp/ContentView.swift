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
                }
            }
            .navigationTitle("📋 Yapılacaklar")
        }
    }
    
    // MARK: - Functions
    private func addTodo() {
        guard !newTodo.isEmpty else { return }
        todos.append(newTodo)
        newTodo = ""
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
