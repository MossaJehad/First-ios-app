import SwiftUI
import SwiftData

public struct AllTasksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoTask.createdAt, order: .reverse) private var tasks: [TodoTask]
    @Binding var isMenuPresented: Bool
    public var onAddTaskTap: () -> Void
    public var onSelectTask: (TodoTask, Int) -> Void
    
    @State private var selectedFilter: String = "ALL"
    
    public init(
        isMenuPresented: Binding<Bool>,
        onAddTaskTap: @escaping () -> Void,
        onSelectTask: @escaping (TodoTask, Int) -> Void
    ) {
        self._isMenuPresented = isMenuPresented
        self.onAddTaskTap = onAddTaskTap
        self.onSelectTask = onSelectTask
    }
    
    private var filteredTasks: [TodoTask] {
        if selectedFilter == "ALL" {
            return tasks
        }
        return tasks.filter { $0.category.label == selectedFilter }
    }
    
    private let filters = ["ALL", "WORK", "PERSONAL", "HEALTH", "STUDY"]
    
    public var body: some View {
        ResponsiveContainer { metrics in
            VStack(spacing: 0) {
                // Top Editorial Header
                EditorialHeader(
                    title: "FOCUS",
                    rightText: "MENU",
                    titleColor: AppColor.red,
                    rightColor: AppColor.paper,
                    onRightTap: {
                        isMenuPresented = true
                    }
                )
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Giant Heading
                        VStack(alignment: .leading, spacing: metrics.heroLineSpacing) {
                            Text("ALL")
                                .font(AppFont.hero(metrics.heroFontSize))
                            Text("TASKS")
                                .font(AppFont.hero(metrics.heroFontSize))
                        }
                        .foregroundStyle(AppColor.paper)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.top, metrics.isCompact ? 6 : 10)
                        .padding(.bottom, metrics.isCompact ? 10 : 14)
                        
                        // Category Filter Bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(filters, id: \.self) { filter in
                                    Button(action: {
                                        AppHaptics.buttonTap()
                                        selectedFilter = filter
                                    }) {
                                        Text(filter)
                                            .font(AppFont.caption(11, bold: true))
                                            .tracking(1.0)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 7)
                                            .background(selectedFilter == filter ? AppColor.paper : Color.clear)
                                            .foregroundStyle(selectedFilter == filter ? AppColor.black : AppColor.paper)
                                            .overlay(
                                                Rectangle()
                                                    .strokeBorder(AppColor.paper.opacity(0.4), lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, metrics.horizontalMargin)
                        }
                        .padding(.bottom, metrics.isCompact ? 12 : 16)
                        
                        EditorialDivider(color: AppColor.darkDivider)
                        
                        // Tasks List
                        if filteredTasks.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("NO TASKS IN \(selectedFilter)")
                                    .font(AppFont.section(20))
                                    .foregroundStyle(AppColor.mutedGray)
                            }
                            .padding(.horizontal, metrics.horizontalMargin)
                            .padding(.vertical, 28)
                        } else {
                            ForEach(Array(filteredTasks.enumerated()), id: \.element.id) { index, task in
                                TaskRow(
                                    index: index + 1,
                                    task: task,
                                    onToggle: {
                                        toggleTask(task)
                                    },
                                    onTap: {
                                        onSelectTask(task, index + 1)
                                    }
                                )
                            }
                        }
                        
                        Spacer(minLength: 16)
                    }
                }
            }
            .background(AppColor.black.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) {
                BottomActionBar(
                    title: "+ NEW TASK",
                    trailingIcon: "→",
                    backgroundColor: AppColor.orange,
                    foregroundColor: AppColor.black
                ) {
                    onAddTaskTap()
                }
            }
        }
    }
    
    private func toggleTask(_ task: TodoTask) {
        task.isCompleted.toggle()
        task.completedAt = task.isCompleted ? Date() : nil
        try? modelContext.save()
    }
}
