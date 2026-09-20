import Foundation
import SwiftData
import SwiftUI

@Observable
public final class TodayViewModel {
    public var modelContext: ModelContext?
    public var isAddTaskPresented: Bool = false
    public var isMenuPresented: Bool = false
    public var selectedTask: TodoTask? = nil
    
    public init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    public func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: Date()).uppercased()
    }
    
    public func toggleTaskCompletion(_ task: TodoTask) {
        task.isCompleted.toggle()
        task.completedAt = task.isCompleted ? Date() : nil
        try? modelContext?.save()
    }
    
    public func deleteTask(_ task: TodoTask) {
        AppHaptics.taskDeleted()
        modelContext?.delete(task)
        try? modelContext?.save()
    }
    
    public func seedSampleDataIfNeeded(tasks: [TodoTask]) {
        guard tasks.isEmpty, let context = modelContext else { return }
        
        let sampleItems: [(String, TaskCategory, TaskPriority, Date?)] = [
            ("FINISH PORTFOLIO", .work, .high, Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())),
            ("REVIEW PR", .work, .medium, Calendar.current.date(bySettingHour: 11, minute: 30, second: 0, of: Date())),
            ("BUY GROCERIES", .personal, .low, Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())),
            ("GYM WORKOUT", .health, .medium, Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: Date())),
            ("READ 20 PAGES", .study, .low, Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()))
        ]
        
        for item in sampleItems {
            let newTask = TodoTask(
                title: item.0,
                notes: "Editorial daily task.",
                createdAt: Date(),
                dueDate: item.3,
                isCompleted: false,
                completedAt: nil,
                priority: item.2,
                category: item.1
            )
            context.insert(newTask)
        }
        try? context.save()
    }
}
