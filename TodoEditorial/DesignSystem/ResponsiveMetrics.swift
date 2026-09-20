import SwiftUI

/// Generic responsive metrics derived strictly from the current container's available dimensions.
/// NEVER checks physical device models or uses UIScreen.main.bounds.
public struct ResponsiveMetrics: Equatable {
    public let width: CGFloat
    public let height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = max(1, width)
        self.height = max(1, height)
    }
    
    /// Compact screen (e.g. iPhone SE, width < 385pt or height < 750pt)
    public var isCompact: Bool {
        width < 385 || height < 750
    }
    
    /// Large screen (e.g. Pro Max, Plus, or iPhone 18 Pro, width >= 430pt or height >= 900pt)
    public var isLarge: Bool {
        width >= 430 || height >= 920
    }
    
    /// Medium standard screen (e.g. iPhone 15, 16, 16 Pro)
    public var isMedium: Bool {
        !isCompact && !isLarge
    }
    
    /// Hero heading typography size (e.g. "READY TO GET SHIT DONE?", "ARCHIVE HISTORY")
    public var heroFontSize: CGFloat {
        if isLarge {
            return min(84, width * 0.20)
        } else if isCompact {
            return max(50, min(56, width * 0.15))
        } else {
            return min(62, width * 0.165)
        }
    }
    
    /// Secondary display font size (e.g. "NEW TASK", "FOCUS", titles)
    public var displayFontSize: CGFloat {
        if isLarge {
            return 68
        } else if isCompact {
            return 46
        } else {
            return 56
        }
    }
    
    /// Massive hero numbers (e.g. 01 in detail, 86 in stats)
    public var heroNumberFontSize: CGFloat {
        if isLarge {
            return 100
        } else if isCompact {
            return 66
        } else {
            return 82
        }
    }
    
    /// Section font size (buttons, action bars, menu items)
    public var sectionFontSize: CGFloat {
        if isCompact {
            return 21
        } else {
            return 24
        }
    }
    
    /// Horizontal screen margin
    public var horizontalMargin: CGFloat {
        if isCompact {
            return 14
        } else {
            return 18
        }
    }
    
    /// Hero title line spacing (tight negative leading for condensed brutalist poster look)
    public var heroLineSpacing: CGFloat {
        if isLarge {
            return -14
        } else if isCompact {
            return -8
        } else {
            return -12
        }
    }
    
    /// Vertical padding for bottom action bars
    public var bottomBarVerticalPadding: CGFloat {
        if isCompact {
            return 11
        } else {
            return 14
        }
    }
}

// MARK: - Environment Key
private struct ResponsiveMetricsKey: EnvironmentKey {
    static let defaultValue = ResponsiveMetrics(width: 393, height: 852)
}

public extension EnvironmentValues {
    var responsiveMetrics: ResponsiveMetrics {
        get { self[ResponsiveMetricsKey.self] }
        set { self[ResponsiveMetricsKey.self] = newValue }
    }
}

// MARK: - Responsive Container View
public struct ResponsiveContainer<Content: View>: View {
    @ViewBuilder private let content: (ResponsiveMetrics) -> Content
    @State private var metrics = ResponsiveMetrics(width: 393, height: 852)
    
    public init(@ViewBuilder content: @escaping (ResponsiveMetrics) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(metrics)
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
    }
}
