import SwiftUI
import CoreText

public enum AppFont {
    public static let displayFontName = "Anton-Regular"
    
    /// Hero massive typography (100 - 170pt)
    public static func hero(_ size: CGFloat = 120) -> Font {
        if isFontAvailable(displayFontName) {
            return .custom(displayFontName, size: size)
        }
        return .system(size: size, weight: .black, design: .default)
    }
    
    /// Display titles and headings (50 - 90pt)
    public static func display(_ size: CGFloat = 68) -> Font {
        if isFontAvailable(displayFontName) {
            return .custom(displayFontName, size: size)
        }
        return .system(size: size, weight: .black, design: .default)
    }
    
    /// Section headings (24 - 38pt)
    public static func section(_ size: CGFloat = 28) -> Font {
        if isFontAvailable(displayFontName) {
            return .custom(displayFontName, size: size)
        }
        return .system(size: size, weight: .heavy, design: .default)
    }
    
    /// Task titles & subheadings (18 - 24pt)
    public static func taskTitle(_ size: CGFloat = 22) -> Font {
        if isFontAvailable(displayFontName) {
            return .custom(displayFontName, size: size)
        }
        return .system(size: size, weight: .bold, design: .default)
    }
    
    /// Body text - Grotesque / Swiss clean style (14 - 17pt)
    public static func body(_ size: CGFloat = 15, bold: Bool = false) -> Font {
        return .system(size: size, weight: bold ? .bold : .medium, design: .default)
    }
    
    /// Monospaced metadata or technical labels (11 - 13pt)
    public static func mono(_ size: CGFloat = 12, bold: Bool = false) -> Font {
        return .system(size: size, weight: bold ? .bold : .medium, design: .monospaced)
    }
    
    /// Small uppercase metadata (11 - 14pt)
    public static func caption(_ size: CGFloat = 12, bold: Bool = true) -> Font {
        return .system(size: size, weight: bold ? .bold : .medium, design: .default)
    }
    
    private static func isFontAvailable(_ name: String) -> Bool {
        UIFont.familyNames.contains { family in
            UIFont.fontNames(forFamilyName: family).contains(name) || family == name
        } || UIFont(name: name, size: 12) != nil
    }
}

public enum FontRegistrar {
    public static func registerFonts() {
        guard let url = Bundle.main.url(forResource: "Anton-Regular", withExtension: "ttf") else {
            // Also search in main bundle subdirectories or module bundle
            if let urls = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil) {
                for fontUrl in urls {
                    CTFontManagerRegisterFontsForURL(fontUrl as CFURL, .process, nil)
                }
            }
            return
        }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}
