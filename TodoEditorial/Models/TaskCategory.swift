import Foundation

public enum TaskCategory: String, Codable, CaseIterable, Identifiable {
    case work = "WORK"
    case personal = "PERSONAL"
    case health = "HEALTH"
    case study = "STUDY"
    case other = "OTHER"
    
    public var id: String { rawValue }
    
    public var label: String {
        rawValue
    }
}
