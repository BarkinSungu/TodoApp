import SwiftUI

struct TaskDetailSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var task: Task     // Gelen task burada düzenlenecek
    @State private var showDeleteAlert = false
    var onDelete: (Task) -> Void
    
    var onSave: (Task) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Görev Detayları")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12){
            TextField("Görev başlığı", text: $task.title)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            TextField("Sıklık (gün)", value: $task.frequency, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            TextField("Süre (dk)", value: $task.duration, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("Bu görev için \(formatDuration(minutes: task.totalTime)) ayrıldı.")
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Text("Bu görev \(task.totalDoneCount) defa tamamlandı.")
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            if let date = task.lastCompletedDate {
                Text("Son Tamamlama: \(date.asDayMonthYear())")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                Text("Henüz tamamlanmamış")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            DatePicker(
                "Sonraki Yapılma Tarihi",
                selection: $task.nextTime, in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .padding(.horizontal)
            }
            
            Button("Kaydet") {
                onSave(task)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        
        Button(role: .destructive) {
            showDeleteAlert = true
        } label: {
            Text("Görevi Sil")
                .frame(maxWidth: .infinity)
        }
        .alert("Bu görevi silmek istediğinize emin misiniz?", isPresented: $showDeleteAlert) {
            Button("Sil", role: .destructive) {
                onDelete(task)  // ContentView’e bildiriyoruz
                dismiss()
            }
            Button("İptal", role: .cancel) { }
        }
        .padding()
    }
    
    func formatDuration(minutes: Int) -> String {
        let days = minutes / 1440
        let hours = (minutes % 1440) / 60
        let mins = minutes % 60

        var parts: [String] = []

        if days > 0 {
            parts.append("\(days) gün")
        }
        if hours > 0 {
            parts.append("\(hours) saat")
        }
        if mins > 0 {
            parts.append("\(mins) dakika")
        }

        // Eğer hepsi 0 ise 0 dakika gösterelim
        if parts.isEmpty {
            return "0 dakika"
        }

        return parts.joined(separator: " ")
    }
}
