import SwiftUI
import SwiftData

public struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: TodoTask
    public let taskIndex: Int
    
    public init(task: TodoTask, taskIndex: Int) {
        self.task = task
        self.taskIndex = taskIndex
    }
    
    private var formattedIndex: String {
        String(format: "%02d", taskIndex)
    }
    
    private var formattedDueDate: String {
        guard let due = task.dueDate else { return "NO TIME SET" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d 'AT' HH:mm"
        return formatter.string(from: due).uppercased()
    }
    
    public var body: some View {
        ResponsiveContainer { metrics in
            VStack(spacing: 0) {
                // Top Editorial Header
                EditorialHeader(
                    title: "FOCUS",
                    rightText: "BACK",
                    titleColor: AppColor.black,
                    rightColor: AppColor.black,
                    onRightTap: {
                        dismiss()
                    }
                )
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Giant Task Index
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: -6) {
                                Text("TASK")
                                    .font(AppFont.section(metrics.isCompact ? 20 : 24))
                                    .tracking(2.0)
                                    .foregroundStyle(AppColor.mutedGray)
                                
                                Text(formattedIndex)
                                    .font(AppFont.hero(metrics.heroNumberFontSize))
                                    .foregroundStyle(AppColor.black)
                            }
                            
                            Spacer()
                            
                            // Brutalist status badge
                            Text(task.isCompleted ? "DONE" : "PENDING")
                                .font(AppFont.caption(11, bold: true))
                                .tracking(1.5)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(task.isCompleted ? AppColor.black : AppColor.orange)
                                .foregroundStyle(task.isCompleted ? AppColor.paper : AppColor.black)
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.top, metrics.isCompact ? 6 : 10)
                        
                        EditorialDivider(color: AppColor.lightDivider)
                            .padding(.vertical, metrics.isCompact ? 10 : 14)
                        
                        // Giant Task Title
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title.uppercased())
                                .font(AppFont.display(metrics.isCompact ? 42 : (metrics.isLarge ? 64 : 48)))
                                .foregroundStyle(task.isCompleted ? AppColor.mutedGray : AppColor.black)
                                .tracking(0.3)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.bottom, metrics.isCompact ? 10 : 14)
                        
                        EditorialDivider(color: AppColor.lightDivider)
                        
                        // Metadata Table
                        VStack(spacing: 0) {
                            editorialMetaRow(title: "CATEGORY", value: task.category.label, margin: metrics.horizontalMargin, isCompact: metrics.isCompact)
                            EditorialDivider(color: AppColor.lightDivider)
                            
                            editorialMetaRow(title: "PRIORITY", value: task.priority.label, isAccent: task.priority == .high, margin: metrics.horizontalMargin, isCompact: metrics.isCompact)
                            EditorialDivider(color: AppColor.lightDivider)
                            
                            editorialMetaRow(title: "SCHEDULE", value: formattedDueDate, margin: metrics.horizontalMargin, isCompact: metrics.isCompact)
                            EditorialDivider(color: AppColor.lightDivider)
                            
                            if !task.notes.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("NOTES")
                                        .font(AppFont.caption(10, bold: true))
                                        .tracking(2.0)
                                        .foregroundStyle(AppColor.mutedGray)
                                    
                                    Text(task.notes)
                                        .font(AppFont.body(13))
                                        .foregroundStyle(AppColor.black.opacity(0.85))
                                        .lineLimit(3)
                                }
                                .padding(.horizontal, metrics.horizontalMargin)
                                .padding(.vertical, metrics.isCompact ? 8 : 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                EditorialDivider(color: AppColor.lightDivider)
                            }
                        }
                        
                        // Action Buttons
                        VStack(spacing: 8) {
                            BrutalistButton(
                                task.isCompleted ? "MARK AS PENDING" : "COMPLETE TASK",
                                trailingIcon: task.isCompleted ? "↺" : "✓",
                                style: .solid(background: AppColor.orange, foreground: AppColor.black),
                                height: metrics.isCompact ? 46 : 50
                            ) {
                                toggleCompletion()
                            }
                            
                            BrutalistButton(
                                "DELETE TASK",
                                trailingIcon: "✕",
                                style: .outline(border: AppColor.red, foreground: AppColor.red),
                                height: metrics.isCompact ? 46 : 50
                            ) {
                                deleteTask()
                            }
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.top, metrics.isCompact ? 12 : 16)
                        .padding(.bottom, 24)
                    }
                }
            }
            .background(AppColor.paper.ignoresSafeArea())
        }
    }
    
    private func editorialMetaRow(title: String, value: String, isAccent: Bool = false, margin: CGFloat, isCompact: Bool) -> some View {
        HStack(alignment: .center) {
            Text(title)
                .font(AppFont.caption(10, bold: true))
                .tracking(2.0)
                .foregroundStyle(AppColor.mutedGray)
                .frame(width: 85, alignment: .leading)
            
            Text(value)
                .font(AppFont.section(isCompact ? 16 : 18))
                .foregroundStyle(isAccent ? AppColor.red : AppColor.black)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer()
        }
        .padding(.horizontal, margin)
        .padding(.vertical, isCompact ? 9 : 11)
    }
    
    private func toggleCompletion() {
        AppHaptics.taskCompleted()
        task.isCompleted.toggle()
        task.completedAt = task.isCompleted ? Date() : nil
        try? modelContext.save()
    }
    
    private func deleteTask() {
        AppHaptics.taskDeleted()
        modelContext.delete(task)
        try? modelContext.save()
        dismiss()
    }
}
