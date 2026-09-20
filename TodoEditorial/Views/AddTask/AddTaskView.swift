import SwiftUI
import SwiftData

public struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var selectedCategory: TaskCategory = .work
    @State private var selectedPriority: TaskPriority = .high
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = true
    
    public init() {}
    
    public var body: some View {
        ResponsiveContainer { metrics in
            VStack(spacing: 0) {
                // Top Header
                EditorialHeader(
                    title: "FOCUS",
                    rightText: "CANCEL",
                    titleColor: AppColor.red,
                    rightColor: AppColor.paper,
                    onRightTap: {
                        dismiss()
                    }
                )
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Hero Display Heading in bright poster red
                        VStack(alignment: .leading, spacing: metrics.heroLineSpacing) {
                            Text("NEW")
                                .font(AppFont.hero(metrics.heroFontSize))
                            Text("TASK")
                                .font(AppFont.hero(metrics.heroFontSize))
                        }
                        .foregroundStyle(AppColor.red)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.top, metrics.isCompact ? 4 : 8)
                        .padding(.bottom, metrics.isCompact ? 12 : 18)
                        
                        EditorialDivider(color: AppColor.red.opacity(0.3))
                        
                        // FIELD 1: TITLE
                        VStack(alignment: .leading, spacing: 6) {
                            Text("TITLE")
                                .font(AppFont.caption(11, bold: true))
                                .tracking(2.0)
                                .foregroundStyle(AppColor.red)
                            
                            TextField("WRITE TASK DESCRIPTION", text: $title)
                                .font(AppFont.section(metrics.isCompact ? 20 : 24))
                                .foregroundStyle(AppColor.paper)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.characters)
                                .tint(AppColor.orange)
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.vertical, metrics.isCompact ? 12 : 15)
                        
                        EditorialDivider(color: AppColor.red.opacity(0.3))
                        
                        // FIELD 2: CATEGORY
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CATEGORY")
                                .font(AppFont.caption(11, bold: true))
                                .tracking(2.0)
                                .foregroundStyle(AppColor.red)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 6) {
                                    ForEach(TaskCategory.allCases) { category in
                                        Button(action: {
                                            AppHaptics.buttonTap()
                                            selectedCategory = category
                                        }) {
                                            Text(category.label)
                                                .font(AppFont.caption(11, bold: true))
                                                .tracking(1.0)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(selectedCategory == category ? AppColor.paper : Color.clear)
                                                .foregroundStyle(selectedCategory == category ? AppColor.black : AppColor.paper.opacity(0.8))
                                                .overlay(
                                                    Rectangle()
                                                        .strokeBorder(selectedCategory == category ? AppColor.paper : AppColor.paper.opacity(0.4), lineWidth: 1)
                                                )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.vertical, metrics.isCompact ? 12 : 15)
                        
                        EditorialDivider(color: AppColor.red.opacity(0.3))
                        
                        // FIELD 3: PRIORITY
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PRIORITY")
                                .font(AppFont.caption(11, bold: true))
                                .tracking(2.0)
                                .foregroundStyle(AppColor.red)
                            
                            HStack(spacing: 8) {
                                ForEach(TaskPriority.allCases) { priority in
                                    Button(action: {
                                        AppHaptics.priorityChanged()
                                        selectedPriority = priority
                                    }) {
                                        Text(priority.label)
                                            .font(AppFont.caption(12, bold: true))
                                            .tracking(1.5)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(selectedPriority == priority ? AppColor.orange : Color.clear)
                                            .foregroundStyle(selectedPriority == priority ? AppColor.black : AppColor.paper)
                                            .overlay(
                                                Rectangle()
                                                    .strokeBorder(selectedPriority == priority ? AppColor.orange : AppColor.paper.opacity(0.4), lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.vertical, metrics.isCompact ? 12 : 15)
                        
                        EditorialDivider(color: AppColor.red.opacity(0.3))
                        
                        // FIELD 4: TIME / SCHEDULE
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("SCHEDULE")
                                    .font(AppFont.caption(11, bold: true))
                                    .tracking(2.0)
                                    .foregroundStyle(AppColor.red)
                                
                                Spacer()
                                
                                Button(action: {
                                    AppHaptics.buttonTap()
                                    hasDueDate.toggle()
                                }) {
                                    Text(hasDueDate ? "TODAY" : "NO TIME")
                                        .font(AppFont.caption(11, bold: true))
                                        .foregroundStyle(hasDueDate ? AppColor.orange : AppColor.paper.opacity(0.6))
                                }
                                .buttonStyle(.plain)
                            }
                            
                            if hasDueDate {
                                DatePicker(
                                    "",
                                    selection: $dueDate,
                                    displayedComponents: [.hourAndMinute]
                                )
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .colorScheme(.dark)
                                .frame(height: 100)
                                .clipped()
                            }
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.vertical, metrics.isCompact ? 12 : 15)
                        
                        EditorialDivider(color: AppColor.red.opacity(0.3))
                        
                        // FIELD 5: NOTES (OPTIONAL)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NOTES")
                                .font(AppFont.caption(11, bold: true))
                                .tracking(2.0)
                                .foregroundStyle(AppColor.red)
                            
                            TextField("OPTIONAL BRIEF DETAILS", text: $notes)
                                .font(AppFont.body(14))
                                .foregroundStyle(AppColor.paper)
                                .tint(AppColor.orange)
                        }
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.vertical, metrics.isCompact ? 12 : 15)
                        
                        Spacer(minLength: 16)
                    }
                }
            }
            .background(AppColor.darkRed.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) {
                BottomActionBar(
                    title: "CREATE TASK",
                    trailingIcon: "→",
                    backgroundColor: AppColor.orange,
                    foregroundColor: AppColor.black
                ) {
                    createTask()
                }
            }
        }
    }
    
    private func createTask() {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        AppHaptics.taskCreated()
        
        let newTask = TodoTask(
            title: trimmed,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            createdAt: Date(),
            dueDate: hasDueDate ? dueDate : nil,
            isCompleted: false,
            completedAt: nil,
            priority: selectedPriority,
            category: selectedCategory
        )
        
        modelContext.insert(newTask)
        try? modelContext.save()
        dismiss()
    }
}
