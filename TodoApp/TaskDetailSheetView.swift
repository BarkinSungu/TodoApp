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
            
            if let date = task.lastCompletedDate {
                Text("Son Tamamlama: \(date.asDayMonthYear())")
                    .foregroundColor(.gray)
            } else {
                Text("Henüz tamamlanmamış")
                    .foregroundColor(.gray)
            }
            
            DatePicker(
                "Sonraki Yapılma Tarihi",
                selection: $task.nextTime, in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .padding(.horizontal)
            
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
}
