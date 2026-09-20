import SwiftUI
import SwiftData

public struct MainContainerView: View {
    @Query(sort: \TodoTask.createdAt, order: .forward) private var tasks: [TodoTask]
    @State private var currentScreen: AppScreen = .today
    @State private var isMenuPresented: Bool = false
    @State private var isAddTaskPresented: Bool = false
    @State private var selectedTaskForDetail: (task: TodoTask, index: Int)? = nil
    
    public init() {}
    
    public var body: some View {
        ZStack {
            switch currentScreen {
            case .today:
                TodayView(
                    onMenuTap: { isMenuPresented = true },
                    onAddTaskTap: { isAddTaskPresented = true },
                    onSelectTask: { task, index in
                        selectedTaskForDetail = (task, index)
                    }
                )
            case .allTasks:
                AllTasksView(
                    isMenuPresented: $isMenuPresented,
                    onAddTaskTap: { isAddTaskPresented = true },
                    onSelectTask: { task, index in
                        selectedTaskForDetail = (task, index)
                    }
                )
            case .stats:
                StatsView(
                    isMenuPresented: $isMenuPresented,
                    onKeepGoingTap: {
                        withAnimation {
                            currentScreen = .today
                        }
                    }
                )
            case .history:
                HistoryView(isMenuPresented: $isMenuPresented)
            }
        }
        .fullScreenCover(isPresented: $isMenuPresented) {
            MenuView(currentScreen: $currentScreen, isPresented: $isMenuPresented)
        }
        .fullScreenCover(isPresented: $isAddTaskPresented) {
            AddTaskView()
        }
        .fullScreenCover(item: Binding(
            get: { selectedTaskForDetail.map { IdentifiableTaskWrapper(task: $0.task, index: $0.index) } },
            set: { selectedTaskForDetail = $0.map { ($0.task, $0.index) } }
        )) { wrapper in
            TaskDetailView(task: wrapper.task, taskIndex: wrapper.index)
        }
        .onAppear {
            let args = ProcessInfo.processInfo.arguments
            if args.contains("-screen-menu") {
                isMenuPresented = true
            } else if args.contains("-screen-add") {
                isAddTaskPresented = true
            } else if args.contains("-screen-stats") {
                currentScreen = .stats
            } else if args.contains("-screen-history") {
                currentScreen = .history
            } else if args.contains("-screen-tasks") {
                currentScreen = .allTasks
            } else if args.contains("-screen-detail") {
                if let first = tasks.first {
                    selectedTaskForDetail = (first, 1)
                }
            }
        }
    }
}

private struct IdentifiableTaskWrapper: Identifiable {
    let task: TodoTask
    let index: Int
    var id: UUID { task.id }
}
