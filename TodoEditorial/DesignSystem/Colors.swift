import SwiftUI

public enum AppColor {
    /// Primary deep black - #171717
    public static let black = Color(hex: 0x171717)
    
    /// Warm off-white / editorial paper - #EEE9DE
    public static let paper = Color(hex: 0xEEE9DE)
    
    /// Strong vibrant orange for primary actions and bottom bar - #FF6A00
    public static let orange = Color(hex: 0xFF6A00)
    
    /// Strong poster red for accents, urgent status, headers - #FF4D43
    public static let red = Color(hex: 0xFF4D43)
    
    /// Dark maroon red for deep brutalist backgrounds - #7F2019
    public static let darkRed = Color(hex: 0x7F2019)
    
    /// Muted gray for completed tasks, secondary metadata, hairline borders - #9B978D
    public static let mutedGray = Color(hex: 0x9B978D)
    
    /// Subtle divider line color for black background
    public static let darkDivider = Color(hex: 0x2A2A2A)
    
    /// Subtle divider line color for paper background
    public static let lightDivider = Color(hex: 0xDCD6C9)
}

public extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
