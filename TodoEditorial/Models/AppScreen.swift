import Foundation

public enum AppScreen: String, CaseIterable, Identifiable {
    case today = "TODAY"
    case allTasks = "TASKS"
    case stats = "STATS"
    case history = "HISTORY"
    
    public var id: String { rawValue }
    
    public var indexString: String {
        switch self {
        case .today: return "01"
        case .allTasks: return "02"
        case .stats: return "03"
        case .history: return "04"
        }
    }
}
