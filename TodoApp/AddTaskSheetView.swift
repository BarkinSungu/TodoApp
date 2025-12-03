import SwiftUI

struct AddTaskSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var titleText = ""
    @State private var nextTime: Date = Calendar.current.startOfDay(for: Date())
    @State private var selectedFrequency: Frequency? = nil
    @State private var duration: Int = 0
    @State private var customDays: String = ""
    var onAdd: (String, Int, DateComponents, Date) -> Void

    var body: some View {
        ZStack {
            AppColors.butterYellowLight
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Yeni Görev Ekle")
                    .font(.headline)
                    .foregroundStyle(AppColors.primaryText)

                TextField("", text: $titleText)
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

                DatePicker(
                    "Sonraki Yapılma Tarihi",
                    selection: $nextTime, in: Date()...,
                    displayedComponents: .date
                )
                .foregroundStyle(AppColors.primaryText)
                .datePickerStyle(.compact)
                .padding(.horizontal)
                .tint(AppColors.primaryText)

                Button("Ekle") {
                    var freq = DateComponents(day: 0)
                    if (selectedFrequency != nil){
                        freq = selectedFrequency?.dateComponents ?? DateComponents(day: 0)
                        if selectedFrequency?.isCustom == true, let customDaysInt = Int(customDays) {
                            freq.day = customDaysInt
                        }
                    }
                    let next: Date = nextTime
                    onAdd(titleText, duration, freq, next)
                    dismiss()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.primaryText)
                .foregroundStyle(AppColors.butterYellow)
                .cornerRadius(12)

            }
            .padding()
            .tint(AppColors.primaryText)
        }
    }

}
