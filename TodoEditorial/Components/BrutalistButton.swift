import SwiftUI

public struct BrutalistButton: View {
    public enum Style {
        case solid(background: Color, foreground: Color)
        case outline(border: Color, foreground: Color)
    }
    
    public var title: String
    public var trailingIcon: String?
    public var style: Style
    public var height: CGFloat
    public var action: () -> Void
    
    public init(
        _ title: String,
        trailingIcon: String? = nil,
        style: Style = .solid(background: AppColor.orange, foreground: AppColor.black),
        height: CGFloat = 58,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.trailingIcon = trailingIcon
        self.style = style
        self.height = height
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            AppHaptics.buttonTap()
            action()
        }) {
            HStack {
                Text(title.uppercased())
                    .font(AppFont.section(24))
                    .tracking(1.0)
                
                if let trailingIcon {
                    Spacer()
                    Text(trailingIcon)
                        .font(AppFont.section(24))
                }
            }
            .padding(.horizontal, AppSpacing.horizontalMargin)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .modifier(BrutalistStyleModifier(style: style))
        }
        .buttonStyle(BrutalistPressEffect())
    }
}

private struct BrutalistStyleModifier: ViewModifier {
    let style: BrutalistButton.Style
    
    func body(content: Content) -> some View {
        switch style {
        case .solid(let background, let foreground):
            content
                .foregroundStyle(foreground)
                .background(background)
        case .outline(let border, let foreground):
            content
                .foregroundStyle(foreground)
                .background(Color.clear)
                .overlay(
                    Rectangle()
                        .strokeBorder(border, lineWidth: 1.5)
                )
        }
    }
}

private struct BrutalistPressEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
