import SwiftUI

struct TaskDetailSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var task: Task
    @State private var showDeleteAlert = false
    @State private var selectedFrequency: Frequency? = nil
    @State private var customDays: String = ""
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
                
                HStack{
                    
                    Text("Sıklık:")
                    Menu {
                        ForEach(presetFrequencies) { freq in
                            Button(freq.title) {
                                selectedFrequency = freq
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedFrequency?.title ?? "Sıklık Seçin")
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    
                    if selectedFrequency?.isCustom == true {
                        TextField("Kaç günde bir?", text: $customDays)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    getFreq()
                }
            
                HStack{
                    Text("Görev Süresi:")
                    TextField("Süre (dk)", value: $task.duration, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    Spacer()
                    Text("dk")
                }
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
                var freq = DateComponents(day: 0)
                if (selectedFrequency != nil){
                    freq = selectedFrequency?.dateComponents ?? DateComponents(day: 0)
                    if selectedFrequency?.isCustom == true, let customDaysInt = Int(customDays) {
                        freq.day = customDaysInt
                    }
                }
                if (task.frequency != freq){
                    task.frequency = freq
                    task.nextTime = Calendar.current.date(byAdding: task.frequency, to: Date.now)!
                }
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
    
    func getFreq(){
        if let found = presetFrequencies.first(where: { $0.dateComponents == task.frequency }) {
            selectedFrequency = found
        }else {
            selectedFrequency = presetFrequencies.last!
            customDays = String(task.frequency.day!)
        }
        
    }
}
