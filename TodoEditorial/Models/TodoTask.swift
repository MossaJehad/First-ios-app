import Foundation
import SwiftData

@Model
public final class TodoTask {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var notes: String
    public var createdAt: Date
    public var dueDate: Date?
    public var isCompleted: Bool
    public var completedAt: Date?
    public var priorityRaw: String
    public var categoryRaw: String
    
    public var priority: TaskPriority {
        get {
            TaskPriority(rawValue: priorityRaw) ?? .medium
        }
        set {
            priorityRaw = newValue.rawValue
        }
    }
    
    public var category: TaskCategory {
        get {
            TaskCategory(rawValue: categoryRaw) ?? .work
        }
        set {
            categoryRaw = newValue.rawValue
        }
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        createdAt: Date = Date(),
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        priority: TaskPriority = .medium,
        category: TaskCategory = .work
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.priorityRaw = priority.rawValue
        self.categoryRaw = category.rawValue
    }
}
