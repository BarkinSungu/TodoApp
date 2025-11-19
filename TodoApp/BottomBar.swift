import SwiftUI

struct BottomBar: View {
    @Binding var selectedTab: Int
    @Binding var showAddSheet: Bool

    var body: some View {
        HStack {
            Button {
                selectedTab = 0   // Bugün
            } label: {
                VStack {
                    Image(systemName: "sun.max.fill")
                    Text("Bugün").font(.caption)
                }
            }
            .frame(maxWidth: .infinity)

            Button {
                showAddSheet = true
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 4)
                    Image(systemName: "plus")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)

            Button {
                selectedTab = 1 // Tüm
            } label: {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Tümü").font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .background(Color(.systemGray6).ignoresSafeArea(edges: .bottom))
    }
}
