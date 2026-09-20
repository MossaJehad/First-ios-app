import SwiftUI
import SwiftData

public struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoTask.createdAt, order: .forward) private var tasks: [TodoTask]
    @State private var viewModel = TodayViewModel()
    @State private var metrics = ResponsiveMetrics(width: 393, height: 852)
    
    public var onMenuTap: (() -> Void)?
    public var onAddTaskTap: (() -> Void)?
    public var onSelectTask: ((TodoTask, Int) -> Void)?
    
    public init(
        onMenuTap: (() -> Void)? = nil,
        onAddTaskTap: (() -> Void)? = nil,
        onSelectTask: ((TodoTask, Int) -> Void)? = nil
    ) {
        self.onMenuTap = onMenuTap
        self.onAddTaskTap = onAddTaskTap
        self.onSelectTask = onSelectTask
    }
    
    private var todayTasks: [TodoTask] {
        tasks
    }
    
    private var pendingCount: Int {
        todayTasks.filter { !$0.isCompleted }.count
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Top Editorial Header
            EditorialHeader(
                title: "FOCUS",
                rightText: "MENU",
                titleColor: AppColor.red,
                rightColor: AppColor.paper,
                onRightTap: {
                    if let onMenuTap {
                        onMenuTap()
                    } else {
                        viewModel.isMenuPresented = true
                    }
                }
            )
            
            // Main Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero Display Heading
                    VStack(alignment: .leading, spacing: metrics.heroLineSpacing) {
                        Text("READY")
                            .font(AppFont.hero(metrics.heroFontSize))
                        Text("TO GET")
                            .font(AppFont.hero(metrics.heroFontSize))
                        Text("SHIT DONE?")
                            .font(AppFont.hero(metrics.heroFontSize))
                    }
                    .foregroundStyle(AppColor.paper)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, metrics.horizontalMargin)
                    .padding(.top, metrics.isCompact ? 4 : 8)
                    .padding(.bottom, metrics.isCompact ? 6 : 10)
                    
                    // Metadata Block
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TODAY")
                            .font(AppFont.caption(11, bold: true))
                            .tracking(1.8)
                            .foregroundStyle(AppColor.mutedGray)
                        
                        Text(viewModel.formattedDate())
                            .font(AppFont.caption(12, bold: true))
                            .tracking(1.8)
                            .foregroundStyle(AppColor.paper)
                        
                        Text("\(todayTasks.count) TASKS (\(pendingCount) PENDING)")
                            .font(AppFont.caption(12, bold: true))
                            .tracking(1.8)
                            .foregroundStyle(AppColor.paper)
                    }
                    .padding(.horizontal, metrics.horizontalMargin)
                    .padding(.bottom, metrics.isCompact ? 8 : 12)
                    
                    // Hairline divider before first task
                    EditorialDivider(color: AppColor.darkDivider, height: AppSpacing.hairline)
                    
                    // Task Rows
                    if todayTasks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("NO TASKS FOR TODAY")
                                .font(AppFont.section(22))
                                .foregroundStyle(AppColor.mutedGray)
                            Text("TAP BELOW TO CREATE YOUR FIRST TASK.")
                                .font(AppFont.caption(12, bold: false))
                                .foregroundStyle(AppColor.mutedGray.opacity(0.8))
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.vertical, 24)
                    } else {
                        ForEach(Array(todayTasks.enumerated()), id: \.element.id) { index, task in
                            TaskRow(
                                index: index + 1,
                                task: task,
                                onToggle: {
                                    viewModel.toggleTaskCompletion(task)
                                },
                                onTap: {
                                    if let onSelectTask {
                                        onSelectTask(task, index + 1)
                                    } else {
                                        viewModel.selectedTask = task
                                    }
                                }
                            )
                        }
                    }
                    
                    Spacer(minLength: 16)
                }
            }
        }
        .environment(\.responsiveMetrics, metrics)
        .overlay {
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        metrics = ResponsiveMetrics(width: proxy.size.width, height: proxy.size.height)
                    }
                    .onChange(of: proxy.size) { _, newSize in
                        metrics = ResponsiveMetrics(width: newSize.width, height: newSize.height)
                    }
            }
            .allowsHitTesting(false)
        }
        .background(AppColor.black.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomActionBar(
                title: "+ ADD TASK",
                trailingIcon: "→",
                backgroundColor: AppColor.orange,
                foregroundColor: AppColor.black
            ) {
                if let onAddTaskTap {
                    onAddTaskTap()
                } else {
                    viewModel.isAddTaskPresented = true
                }
            }
            .environment(\.responsiveMetrics, metrics)
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.seedSampleDataIfNeeded(tasks: tasks)
        }
    }
}
