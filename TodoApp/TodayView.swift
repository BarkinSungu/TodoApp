import SwiftUI

struct TodayView: View {
    @Binding var tasks: [Task]
    let storage: TaskStorage
    
    @State private var pendingTaskToComplete: Task? = nil
    @State private var showCompleteConfirm: Bool = false
    @State private var showCelebration = false
    @State private var showSuccessBanner = false
    
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
                                .fill(AppColors.butterYellowDark.opacity(0.8))
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
                                    .foregroundStyle(AppColors.secondaryText.opacity(0.5))
                                Spacer()
                                Text("\(task.duration) dk")
                                    .foregroundStyle(AppColors.secondaryText.opacity(0.5))
                                    .italic()
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(AppColors.butterYellowDark.opacity(0.25))
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
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 66)
                }
                
                // Celebration overlays
                if showCelebration {
                    ConfettiOverlay()
                        .transition(.opacity)
                        .ignoresSafeArea()
                }
                if showSuccessBanner {
                    VStack {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.white)
                                .imageScale(.large)
                            Text("Bugünkü tüm görevlerini tamamladın!")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.green.opacity(0.95))
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                        )
                        .padding(.top, 8)
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showSuccessBanner)
                }
                
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
                
                VStack {
                    Spacer()
                    AdBannerView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                        .frame(height: 50)
                        .padding(.bottom, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(AppColors.butterYellowDark.opacity(0.2))
                        )
                        .padding(.horizontal, 16)
                }
                .ignoresSafeArea(edges: .bottom)
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
            NotificationManager.shared.scheduleNotifications(tasks)
            
            DispatchQueue.main.async {
                if allTodayTasksCompleted() {
                    triggerCelebration()
                }
            }
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
    
    private func allTodayTasksCompleted() -> Bool {
        let pending = getTodaysTasks(tasks: tasks)
        return pending.isEmpty
    }

    private func triggerCelebration() {
        guard !showCelebration && !showSuccessBanner else { return }
        withAnimation(.easeIn(duration: 0.2)) {
            showCelebration = true
            showSuccessBanner = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.4)) {
                showSuccessBanner = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut(duration: 0.6)) {
                showCelebration = false
            }
        }
    }
    
}

fileprivate struct ConfettiOverlay: View {
    @State private var particles: [ConfettiParticle] = (0..<40).map { _ in ConfettiParticle() }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles.indices, id: \.self) { i in
                    let p = particles[i]
                    ConfettiShape()
                        .fill(p.color)
                        .frame(width: p.size, height: p.size)
                        .rotationEffect(.degrees(p.rotation))
                        .position(x: p.x * geo.size.width, y: p.y * geo.size.height)
                        .opacity(p.opacity)
                        .animation(
                            .interpolatingSpring(stiffness: 15, damping: 8).delay(p.delay),
                            value: particles
                        )
                }
            }
            .onAppear {
                for i in particles.indices {
                    particles[i].x = Double.random(in: 0.05...0.95)
                    particles[i].y = -0.1
                    particles[i].opacity = 0
                    particles[i].rotation = Double.random(in: -30...30)
                    particles[i].delay = Double.random(in: 0...0.3)
                }
                DispatchQueue.main.async {
                    for i in particles.indices {
                        particles[i].y = 1.2
                        particles[i].opacity = 1
                        particles[i].rotation += Double.random(in: 180...720)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}

fileprivate struct ConfettiParticle: Equatable {
    var x: Double = 0.5
    var y: Double = 0
    var size: CGFloat = CGFloat.random(in: 8...14)
    var color: Color = [Color.green, Color.mint, Color.cyan, Color.yellow, Color.orange].randomElement()!
    var rotation: Double = 0
    var opacity: Double = 1
    var delay: Double = 0
}

fileprivate struct ConfettiShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.addRoundedRect(in: CGRect(x: 0, y: 0, width: w, height: h), cornerSize: CGSize(width: w*0.3, height: h*0.3))
        return p
    }
}
