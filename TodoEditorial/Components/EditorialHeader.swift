import SwiftUI

public struct EditorialHeader: View {
    @Environment(\.responsiveMetrics) private var metrics
    
    public var title: String
    public var rightText: String?
    public var titleColor: Color
    public var rightColor: Color
    public var onRightTap: (() -> Void)?
    
    public init(
        title: String = "FOCUS",
        rightText: String? = "MENU",
        titleColor: Color = AppColor.red,
        rightColor: Color = AppColor.paper,
        onRightTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.rightText = rightText
        self.titleColor = titleColor
        self.rightColor = rightColor
        self.onRightTap = onRightTap
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            Text(title.uppercased())
                .font(AppFont.caption(14, bold: true))
                .tracking(2.5)
                .foregroundStyle(titleColor)
            
            Spacer()
            
            if let rightText {
                Button(action: {
                    AppHaptics.buttonTap()
                    onRightTap?()
                }) {
                    Text(rightText.uppercased())
                        .font(AppFont.caption(12, bold: true))
                        .tracking(2.0)
                        .foregroundStyle(rightColor)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, metrics.horizontalMargin)
        .padding(.top, metrics.isCompact ? 6 : 10)
        .padding(.bottom, metrics.isCompact ? 6 : 8)
    }
}
