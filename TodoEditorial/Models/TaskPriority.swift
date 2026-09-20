import Foundation

public enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    
    public var id: String { rawValue }
    
    public var label: String {
        rawValue
    }
    
    public var displayOrder: Int {
        switch self {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
}
