import SwiftUI

public struct TaskRow: View {
    @Environment(\.responsiveMetrics) private var metrics
    
    public let index: Int
    public let task: TodoTask
    public let onToggle: () -> Void
    public let onTap: () -> Void
    
    @State private var isAnimatingCompletion: Bool = false
    @State private var strikeWidthRatio: CGFloat = 0.0
    @State private var textScale: CGFloat = 1.0
    
    public init(
        index: Int,
        task: TodoTask,
        onToggle: @escaping () -> Void,
        onTap: @escaping () -> Void
    ) {
        self.index = index
        self.task = task
        self.onToggle = onToggle
        self.onTap = onTap
    }
    
    private var formattedIndex: String {
        String(format: "%02d", index)
    }
    
    private var formattedTime: String? {
        guard let due = task.dueDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: due)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                onTap()
            }) {
                HStack(alignment: .top, spacing: metrics.isCompact ? 10 : AppSpacing.md) {
                    // 2-digit brutalist index
                    Text(formattedIndex)
                        .font(AppFont.section(metrics.isCompact ? 22 : 26))
                        .foregroundStyle(task.isCompleted ? AppColor.mutedGray : AppColor.paper.opacity(0.95))
                        .frame(width: metrics.isCompact ? 32 : 38, alignment: .leading)
                    
                    // Task Details
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .leading) {
                            Text(task.title.uppercased())
                                .font(AppFont.taskTitle(metrics.isCompact ? 19 : 22))
                                .tracking(0.3)
                                .foregroundStyle(task.isCompleted ? AppColor.mutedGray : AppColor.paper)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .scaleEffect(textScale, anchor: .leading)
                            
                            // Editorial bold sweep strikethrough (zero GeometryReader needed)
                            Rectangle()
                                .fill(task.isCompleted ? AppColor.mutedGray : Color.clear)
                                .frame(height: 2.5)
                                .scaleEffect(x: strikeWidthRatio, y: 1.0, anchor: .leading)
                        }
                        
                        // Metadata (Time and Category)
                        HStack(spacing: 6) {
                            if let time = formattedTime {
                                Text(time)
                                    .font(AppFont.caption(11, bold: true))
                                    .foregroundStyle(task.isCompleted ? AppColor.mutedGray.opacity(0.6) : AppColor.paper.opacity(0.7))
                            }
                            
                            if formattedTime != nil {
                                Text("•")
                                    .font(AppFont.caption(9))
                                    .foregroundStyle(AppColor.mutedGray.opacity(0.6))
                            }
                            
                            Text(task.category.label)
                                .font(AppFont.caption(10, bold: true))
                                .tracking(1.0)
                                .foregroundStyle(task.isCompleted ? AppColor.mutedGray.opacity(0.6) : AppColor.red)
                            
                            if task.priority == .high && !task.isCompleted {
                                Text("!")
                                    .font(AppFont.caption(11, bold: true))
                                    .foregroundStyle(AppColor.orange)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Custom Brutalist Checkbox
                    CustomCheckbox(
                        isChecked: task.isCompleted,
                        activeColor: AppColor.paper,
                        checkColor: AppColor.black,
                        borderColor: task.isCompleted ? AppColor.mutedGray : AppColor.paper
                    ) {
                        handleToggle()
                    }
                    .padding(.top, 2)
                }
                .padding(.horizontal, metrics.horizontalMargin)
                .padding(.vertical, metrics.isCompact ? 11 : 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            // Thin horizontal editorial divider
            EditorialDivider(color: AppColor.darkDivider, height: AppSpacing.hairline)
        }
        .onAppear {
            strikeWidthRatio = task.isCompleted ? 1.0 : 0.0
        }
        .onChange(of: task.isCompleted) { _, newValue in
            animateCompletion(isCompleted: newValue)
        }
    }
    
    private func handleToggle() {
        AppHaptics.taskCompleted()
        onToggle()
    }
    
    private func animateCompletion(isCompleted: Bool) {
        if isCompleted {
            withAnimation(.easeOut(duration: 0.12)) {
                textScale = 1.05
            }
            withAnimation(.easeOut(duration: 0.28).delay(0.06)) {
                strikeWidthRatio = 1.0
                textScale = 1.0
            }
        } else {
            withAnimation(.easeOut(duration: 0.2)) {
                strikeWidthRatio = 0.0
                textScale = 1.0
            }
        }
    }
}
