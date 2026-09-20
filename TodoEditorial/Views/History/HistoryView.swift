import SwiftUI
import SwiftData

public struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<TodoTask> { $0.isCompleted }, sort: \TodoTask.completedAt, order: .reverse) private var completedTasks: [TodoTask]
    @Binding var isMenuPresented: Bool
    
    public init(isMenuPresented: Binding<Bool>) {
        self._isMenuPresented = isMenuPresented
    }
    
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
                        // Hero Heading
                        VStack(alignment: .leading, spacing: metrics.heroLineSpacing) {
                            Text("ARCHIVE")
                                .font(AppFont.hero(metrics.heroFontSize))
                            Text("HISTORY")
                                .font(AppFont.hero(metrics.heroFontSize))
                        }
                        .foregroundStyle(AppColor.paper)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.top, metrics.isCompact ? 6 : 10)
                        .padding(.bottom, metrics.isCompact ? 10 : 14)
                        
                        // Metadata Counter
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TOTAL ARCHIVED")
                                .font(AppFont.caption(11, bold: true))
                                .tracking(2.0)
                                .foregroundStyle(AppColor.mutedGray)
                            
                            Text("\(completedTasks.count) COMPLETED TASKS")
                                .font(AppFont.caption(12, bold: true))
                                .tracking(1.8)
                                .foregroundStyle(AppColor.paper)
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.bottom, metrics.isCompact ? 12 : 16)
                        
                        EditorialDivider(color: AppColor.darkDivider)
                        
                        if completedTasks.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("NO ARCHIVED TASKS")
                                    .font(AppFont.section(20))
                                    .foregroundStyle(AppColor.mutedGray)
                                Text("COMPLETE TASKS TO SEE THEM HERE.")
                                    .font(AppFont.caption(12, bold: false))
                                    .foregroundStyle(AppColor.mutedGray.opacity(0.8))
                            }
                            .padding(.horizontal, metrics.horizontalMargin)
                            .padding(.vertical, 28)
                        } else {
                            ForEach(Array(completedTasks.enumerated()), id: \.element.id) { index, task in
                                historyRow(index: index + 1, task: task, margin: metrics.horizontalMargin, isCompact: metrics.isCompact)
                                EditorialDivider(color: AppColor.darkDivider)
                            }
                        }
                        
                        Spacer(minLength: 16)
                    }
                }
            }
            .background(AppColor.black.ignoresSafeArea())
        }
    }
    
    private func historyRow(index: Int, task: TodoTask, margin: CGFloat, isCompact: Bool) -> some View {
        HStack(alignment: .top, spacing: isCompact ? 10 : AppSpacing.md) {
            Text(String(format: "%02d", index))
                .font(AppFont.section(isCompact ? 20 : 24))
                .foregroundStyle(AppColor.mutedGray)
                .frame(width: isCompact ? 32 : 38, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(task.title.uppercased())
                    .font(AppFont.taskTitle(isCompact ? 18 : 20))
                    .foregroundStyle(AppColor.mutedGray)
                    .strikethrough(true, color: AppColor.mutedGray)
                
                HStack(spacing: 6) {
                    Text(task.category.label)
                        .font(AppFont.caption(10, bold: true))
                        .foregroundStyle(AppColor.mutedGray.opacity(0.7))
                    
                    if let completed = task.completedAt {
                        Text("•")
                            .foregroundStyle(AppColor.mutedGray.opacity(0.5))
                        Text(formatDate(completed))
                            .font(AppFont.caption(10, bold: true))
                            .foregroundStyle(AppColor.mutedGray.opacity(0.7))
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                restoreTask(task)
            }) {
                Text("RESTORE")
                    .font(AppFont.caption(10, bold: true))
                    .tracking(1.0)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 5)
                    .overlay(
                        Rectangle()
                            .strokeBorder(AppColor.mutedGray.opacity(0.6), lineWidth: 1)
                    )
                    .foregroundStyle(AppColor.paper)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, margin)
        .padding(.vertical, isCompact ? 11 : 14)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter.string(from: date).uppercased()
    }
    
    private func restoreTask(_ task: TodoTask) {
        AppHaptics.taskCreated()
        task.isCompleted = false
        task.completedAt = nil
        try? modelContext.save()
    }
}
