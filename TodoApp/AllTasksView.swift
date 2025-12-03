import SwiftUI

struct AllTasksView: View {
    @Binding var tasks: [Task]
    let storage: TaskStorage
    var onTaskTap: (Task) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.butterYellow
                    .ignoresSafeArea()
                List {
                    ForEach(getAllTasks(tasks: tasks)) { task in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack{
                                Button {
                                    onTaskTap(task)
                                } label: {
                                    Text(task.title)
                                        .foregroundStyle(AppColors.primaryText)
                                }
                                Spacer()
                            }
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(AppColors.butterYellowDark.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppColors.primaryText.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listRowBackground(AppColors.butterYellowDark)
                }
                .scrollContentBackground(.hidden)
                .tint(.black)
            }
            .navigationTitle("Tüm Görevler")
            .toolbarBackground(AppColors.butterYellow)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
    
    func getAllTasks(tasks: [Task]) -> [Task] {
        return tasks.filter { task in
            
            if (task.frequency == DateComponents(year: nil, month: nil, day: 0) && task.lastCompletedDate != nil){
                return false
            }
            return true
        }
    }
}
