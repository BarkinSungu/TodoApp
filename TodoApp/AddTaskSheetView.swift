import SwiftUI

struct AddTaskSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var titleText = ""
    @State private var nextTime: Date = Calendar.current.startOfDay(for: Date())
    @State private var selectedFrequency: Frequency? = nil
    @State private var duration: Int = 0
    @State private var customDays: String = ""
    @State private var haveReminder: Bool = false
    @State private var reminderClock: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    @FocusState private var isFocused: Bool
    var onAdd: (String, Int, DateComponents, Date, Bool, DateComponents?) -> Void

    var body: some View {
        ZStack {
            AppColors.butterYellowLight
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Yeni Görev Ekle")
                    .font(.headline)
                    .foregroundStyle(AppColors.primaryText)

                TextField("", text: $titleText)
                    .focused($isFocused)
                    .placeholder(when: titleText.isEmpty){
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
                            Spacer()
                            Image(systemName: "chevron.down")
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

                HStack{
                    Text("Görev Süresi:")
                        .foregroundStyle(AppColors.primaryText)
                    TextField("Süre (dk)", value: $duration, formatter: NumberFormatter())
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

                Toggle(isOn: $haveReminder) {
                    Text("Hatırlatıcı")
                        .foregroundStyle(AppColors.primaryText)
                }
                .padding(.horizontal)
                .tint(AppColors.primaryText)

                if haveReminder {
                    DatePicker(
                        "Hatırlatma Saati",
                        selection: $reminderClock,
                        displayedComponents: .hourAndMinute
                    )
                    .foregroundStyle(AppColors.primaryText)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .tint(AppColors.primaryText)
                }

                DatePicker(
                    "Sonraki Yapılma Tarihi",
                    selection: $nextTime, in: Date()...,
                    displayedComponents: .date
                )
                .onChange(of: nextTime) { newValue in
                    nextTime = Calendar.current.startOfDay(for: newValue)
                }
                .foregroundStyle(AppColors.primaryText)
                .datePickerStyle(.compact)
                .padding(.horizontal)
                .tint(AppColors.primaryText)

                Button {
                    var freq = DateComponents(day: 0)
                    if (selectedFrequency != nil){
                        freq = selectedFrequency?.dateComponents ?? DateComponents(day: 0)
                        if selectedFrequency?.isCustom == true, let customDaysInt = Int(customDays) {
                            freq.day = customDaysInt
                        }
                    }
                    let next: Date = nextTime
                    let reminderComponents: DateComponents? = haveReminder ? Calendar.current.dateComponents([.hour, .minute], from: reminderClock) : nil
                    onAdd(titleText, duration, freq, next, haveReminder, reminderComponents)
                    dismiss()
                } label :{
                    Text("Ekle")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColors.butterGreen.opacity(0.7))
                        .foregroundStyle(AppColors.primaryText)
                        .cornerRadius(12)
                }
                .padding(.horizontal)               

            }
            .onAppear {
                DispatchQueue.main.async {
                    isFocused = true
                }
            }
            .padding()
            .tint(AppColors.primaryText)
        }
    }

}
