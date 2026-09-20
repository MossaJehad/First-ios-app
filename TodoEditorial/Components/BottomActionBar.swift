import SwiftUI

public struct BottomActionBar: View {
    @Environment(\.responsiveMetrics) private var metrics
    
    public var title: String
    public var subtitle: String?
    public var trailingIcon: String?
    public var backgroundColor: Color
    public var foregroundColor: Color
    public var action: () -> Void
    
    public init(
        title: String = "+ ADD TASK",
        subtitle: String? = nil,
        trailingIcon: String? = "→",
        backgroundColor: Color = AppColor.orange,
        foregroundColor: Color = AppColor.black,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailingIcon = trailingIcon
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            AppHaptics.buttonTap()
            action()
        }) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title.uppercased())
                        .font(AppFont.section(metrics.sectionFontSize + 2))
                        .foregroundStyle(foregroundColor)
                        .tracking(0.5)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    if let subtitle {
                        Text(subtitle.uppercased())
                            .font(AppFont.caption(11, bold: true))
                            .foregroundStyle(foregroundColor.opacity(0.8))
                            .tracking(1.5)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                if let trailingIcon {
                    Text(trailingIcon)
                        .font(AppFont.section(metrics.sectionFontSize + 4))
                        .foregroundStyle(foregroundColor)
                }
            }
            .padding(.horizontal, metrics.horizontalMargin)
            .padding(.top, metrics.bottomBarVerticalPadding)
            .padding(.bottom, metrics.bottomBarVerticalPadding)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
