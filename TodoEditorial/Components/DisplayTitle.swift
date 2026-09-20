import SwiftUI

public struct DisplayTitle: View {
    @Environment(\.responsiveMetrics) private var metrics
    
    public var lines: [String]
    public var customSize: CGFloat?
    public var color: Color
    public var alignment: HorizontalAlignment
    public var customLineSpacing: CGFloat?
    
    public init(
        _ text: String,
        size: CGFloat? = nil,
        color: Color = AppColor.paper,
        alignment: HorizontalAlignment = .leading,
        lineSpacing: CGFloat? = nil
    ) {
        self.lines = text.components(separatedBy: "\n")
        self.customSize = size
        self.color = color
        self.alignment = alignment
        self.customLineSpacing = lineSpacing
    }
    
    public init(
        lines: [String],
        size: CGFloat? = nil,
        color: Color = AppColor.paper,
        alignment: HorizontalAlignment = .leading,
        lineSpacing: CGFloat? = nil
    ) {
        self.lines = lines
        self.customSize = size
        self.color = color
        self.alignment = alignment
        self.customLineSpacing = lineSpacing
    }
    
    private var resolvedSize: CGFloat {
        customSize ?? metrics.heroFontSize
    }
    
    private var resolvedLineSpacing: CGFloat {
        customLineSpacing ?? metrics.heroLineSpacing
    }
    
    public var body: some View {
        VStack(alignment: alignment, spacing: resolvedLineSpacing) {
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                Text(line.uppercased())
                    .font(AppFont.hero(resolvedSize))
                    .foregroundStyle(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .textCase(.uppercase)
                    .tracking(-0.5)
            }
        }
        .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : (alignment == .trailing ? .trailing : .center))
    }
}
