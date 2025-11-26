//
//  AddTaskSheetView.swift
//  TodoApp
//
//  Created by Barkın Süngü on 18.11.2025.
//

import SwiftUI

struct AddTaskSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var titleText = ""
    @State private var frequencyText: String = ""
    @State private var nextTime: Date = Calendar.current.startOfDay(for: Date())
    var onAdd: (String, Int, Date) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Yeni Görev Ekle").font(.headline)

            TextField("Görev başlığı...", text: $titleText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            TextField("Sıklık (gün)", text: $frequencyText)
                .keyboardType(.numberPad) // Numeric keyboard
                .onChange(of: frequencyText) { oldValue, newValue in
                    // Sadece rakamları kabul et
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered != newValue {
                        frequencyText = filtered
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)

            DatePicker("Sonraki Yapılma Tarihi", selection: $nextTime, in: Date()..., displayedComponents: [.date])
                .datePickerStyle(.compact)
                .padding(.horizontal)


            Button("Ekle") {
                let freq = Int(frequencyText) ?? 0
                let next: Date = nextTime
                onAdd(titleText, freq, next)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

