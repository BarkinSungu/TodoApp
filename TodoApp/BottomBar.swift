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
                        .font(.system(size: 30, weight: .medium))
                }
                .foregroundStyle(AppColors.primaryText.opacity(0.75))
            }
            .frame(maxWidth: .infinity)
            
            Button {
                showAddSheet = true
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(AppColors.butterGreen.opacity(0.9))
                        .frame(width: 70, height: 70)
                        .shadow(radius: 4)
                    Image(systemName: "plus")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(AppColors.butterYellow)
                }
                .padding(.bottom, 20)
                .offset(y: -5)
            }
            .frame(maxWidth: .infinity)
            
            Button {
                selectedTab = 1 // Tüm
            } label: {
                VStack {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 30, weight: .medium))
                }
                .foregroundStyle(AppColors.primaryText.opacity(0.75))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.top, -10)
        .tint(AppColors.primaryText)
        .background(AppColors.butterYellowDark.ignoresSafeArea(edges: .bottom))
    }
}
