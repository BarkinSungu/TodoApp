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
                            .foregroundStyle(AppColors.primaryText)
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
                            .foregroundStyle(AppColors.primaryText)
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
                            .foregroundStyle(AppColors.primaryText)
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
                    .onChange(of: task.nextTime) { newValue in
                        task.nextTime = Calendar.current.startOfDay(for: newValue)
                    }
                    .foregroundStyle(AppColors.primaryText)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .tint(AppColors.primaryText)
                }
                .tint(AppColors.primaryText)
                
                Button {
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
                } label: {
                    Text("Kaydet")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColors.butterGreen.opacity(0.7))
                        .foregroundStyle(AppColors.primaryText)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Text("Görevi Sil")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(AppColors.primaryText)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(AppColors.butterRed.opacity(0.8))
                        )
                }
                .padding(.horizontal)
            }
            .padding()
            
            if showDeleteAlert {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.2)) { showDeleteAlert = false }
                    }

                VStack(spacing: 16) {
                    Text("\"\(task.title)\" silinsin mi?")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(AppColors.primaryText)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        // Cancel
                        Button {
                            withAnimation(.spring(duration: 0.2)) {
                                showDeleteAlert = false
                            }
                        } label: {
                            Text("Hayır")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundStyle(AppColors.primaryText)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(AppColors.butterRed.opacity(0.9))
                                )
                        }

                        // Confirm
                        Button {
                            onDelete(task)
                            dismiss()
                            withAnimation(.spring(duration: 0.2)) {
                                showDeleteAlert = false
                            }
                        } label: {
                            Text("Evet")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundStyle(AppColors.butterYellow)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(AppColors.butterGreen.opacity(0.9))
                                )
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppColors.butterYellowLight)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 24)
                .transition(.scale.combined(with: .opacity))
            }
 
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
