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
        ZStack {
            AppColors.butterYellowLight
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Görev Detayları")
                    .font(.headline)
                    .foregroundStyle(AppColors.primaryText)
                
                VStack(alignment: .leading, spacing: 12){
                    TextField("", text: $task.title)
                        .placeholder(when: task.title.isEmpty){
                            Text("Görev başlığı")
                                .foregroundStyle(AppColors.secondaryText)
                                .italic()
                        }
                        .foregroundStyle(AppColors.primaryText)
                        .padding(.horizontal)
                        .padding(12)
                        .background(AppColors.butterYellowDark.opacity(0.25))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1))
                        .cornerRadius(10)
                    
                    HStack{
                        
                        Text("Sıklık:")
                            .foregroundStyle(AppColors.secondaryText)
                        Menu {
                            ForEach(presetFrequencies) { freq in
                                Button(freq.title) {
                                    selectedFrequency = freq
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedFrequency?.title ?? "Sıklık Seçin")
                                    .foregroundStyle(AppColors.primaryText)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(AppColors.primaryText)
                            }
                            .padding()
                            .background(AppColors.butterYellowDark.opacity(0.6))
                            .cornerRadius(8)
                        }
                        
                        if selectedFrequency?.isCustom == true {
                            TextField("Kaç günde bir?", text: $customDays)
                                .keyboardType(.numberPad)
                                .foregroundStyle(AppColors.primaryText)
                                .padding(.horizontal)
                                .padding(12)
                                .background(AppColors.butterYellowDark.opacity(0.25))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        getFreq()
                    }
                    
                    HStack{
                        Text("Görev Süresi:")
                            .foregroundStyle(AppColors.secondaryText)
                        TextField("Süre (dk)", value: $task.duration, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .foregroundStyle(AppColors.primaryText)
                            .padding(.horizontal)
                            .padding(12)
                            .background(AppColors.butterYellowDark.opacity(0.25))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1))
                            .cornerRadius(10)
                        Spacer()
                        Text("dk")
                            .foregroundStyle(AppColors.secondaryText)
                    }
                    .padding(.horizontal)
                    
                    
                    Text("Bu görev için \(formatDuration(minutes: task.totalTime)) ayrıldı.")
                        .foregroundStyle(AppColors.secondaryText)
                        .italic()
                        .padding(.horizontal)
                    
                    Text("Bu görev \(task.totalDoneCount) defa tamamlandı.")
                        .foregroundStyle(AppColors.secondaryText)
                        .italic()
                        .padding(.horizontal)
                    
                    if let date = task.lastCompletedDate {
                        Text("Son Tamamlama: \(date.asDayMonthYear())")
                            .foregroundStyle(AppColors.secondaryText)
                            .italic()
                            .padding(.horizontal)
                    } else {
                        Text("Henüz tamamlanmamış")
                            .foregroundStyle(AppColors.secondaryText)
                            .italic()
                            .padding(.horizontal)
                    }
                    
                    DatePicker(
                        "Sonraki Yapılma Tarihi",
                        selection: $task.nextTime, in: Date()...,
                        displayedComponents: .date
                    )
                    .foregroundStyle(AppColors.primaryText)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .tint(AppColors.primaryText)
                }
                .tint(AppColors.primaryText)
                
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
                .padding(.horizontal)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.butterYellowDark)
                .foregroundStyle(AppColors.primaryText)
                .cornerRadius(12)
                
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
            .padding()
            
        }
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
