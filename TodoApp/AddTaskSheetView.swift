//
//  AddTaskSheetView.swift
//  TodoApp
//
//  Created by Barkın Süngü on 18.11.2025.
//

import SwiftUI

struct AddTaskSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newTitle = ""
    var onAdd: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Yeni Görev Ekle").font(.headline)

            TextField("Görev başlığı...", text: $newTitle)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Ekle") {
                onAdd(newTitle)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
