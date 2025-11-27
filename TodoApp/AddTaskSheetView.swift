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
        VStack(spacing: 20) {
            Text("Yeni Görev Ekle").font(.headline)
            
            TextField("Görev başlığı...", text: $titleText)
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
            
            HStack{
                Text("Görev Süresi:")
                TextField("Süre (dk)", value: $duration, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                Spacer()
                Text("dk")
            }
            .padding(.horizontal)

            DatePicker("Sonraki Yapılma Tarihi", selection: $nextTime, in: Date()..., displayedComponents: [.date])
                .datePickerStyle(.compact)
                .padding(.horizontal)
                        
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
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
}
