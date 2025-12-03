import SwiftUI

struct TodayView: View {
    @Binding var tasks: [Task]
    let storage: TaskStorage
    
    @State private var pendingTaskToComplete: Task? = nil
    @State private var showCompleteConfirm: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.butterYellow
                    .ignoresSafeArea()
                List {
                    ForEach(getTodaysTasks(tasks: tasks)) { task in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack{
                                Text(task.title)
                                    .foregroundStyle(AppColors.primaryText)
                                Spacer()
                                Text("\(task.duration) dk")
                                    .foregroundStyle(AppColors.secondaryText)
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(AppColors.butterYellowDark.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppColors.primaryText.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            pendingTaskToComplete = task
                            withAnimation(.spring(duration: 0.25)) {
                                showCompleteConfirm = true
                            }
                        }
                    }
                    
                    ForEach(getCompletedTasks(tasks: tasks)) { task in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack{
                                Text(task.title)
                                    .strikethrough()
                                    .italic()
                                    .foregroundStyle(AppColors.secondaryText)
                                Spacer()
                                Text("\(task.duration) dk")
                                    .foregroundStyle(AppColors.secondaryText)
                                    .italic()
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(AppColors.butterYellowDark.opacity(0.45))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppColors.primaryText.opacity(0.06), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .tint(.black)
                
                if showCompleteConfirm, let pTask = pendingTaskToComplete {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) { showCompleteConfirm = false }
                        }

                    VStack(spacing: 16) {
                        Text("\"\(pTask.title)\" tamamlandı olarak işaretlensin mi?")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(AppColors.primaryText)
                            .padding(.horizontal)

                        HStack(spacing: 12) {
                            // Cancel
                            Button {
                                withAnimation(.spring(duration: 0.2)) {
                                    showCompleteConfirm = false
                                    pendingTaskToComplete = nil
                                }
                            } label: {
                                Text("Hayır")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .foregroundStyle(AppColors.primaryText)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color(red: 0.95, green: 0.45, blue: 0.45).opacity(0.9))
                                    )
                            }

                            // Confirm
                            Button {
                                if let id = pTask.id as UUID? {
                                    completeTask(id: id)
                                }
                                withAnimation(.spring(duration: 0.2)) {
                                    showCompleteConfirm = false
                                    pendingTaskToComplete = nil
                                }
                            } label: {
                                Text("Evet")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .foregroundStyle(AppColors.butterYellow)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color(red: 0.32, green: 0.6, blue: 0.36))
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
            .navigationTitle("Bugün")
            .toolbarBackground(AppColors.butterYellow)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
    
    private func completeTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].lastCompletedDate = todayDateOnly()
            tasks[index].nextTime = Calendar.current.date(byAdding: tasks[index].frequency, to: todayDateOnly())!
            tasks[index].totalTime = tasks[index].totalTime + tasks[index].duration
            tasks[index].totalDoneCount = tasks[index].totalDoneCount + 1
            storage.saveTasks(tasks)
            print(tasks)
        }
    }
    
    public func todayDateOnly() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components)!   // sadece yıl-ay-gün
    }
    
    func getTodaysTasks(tasks: [Task]) -> [Task]{
        let today = todayDateOnly()
        
        return tasks.filter { task in
            let lastCompletedDate = task.lastCompletedDate
            let nextTime = task.nextTime
            let frequency = task.frequency
            let isOneTime = frequency.year == nil && frequency.month == nil && frequency.day == 0
            
            if lastCompletedDate == today {
                return false
            }
            
            if nextTime == today {
                return true
            }
            
            if nextTime < today {
                if isOneTime{
                    if lastCompletedDate != nil{
                        return false
                    }else{
                        return true
                    }
                }else{
                    return true
                }
            }
            
            return false
        }
    }
    
    func getCompletedTasks(tasks: [Task]) -> [Task]{
        let today = todayDateOnly()
        
        return tasks.filter { task in
            
            if (task.lastCompletedDate == today){
                return true
            }
            return false
        }
    }
    
}
