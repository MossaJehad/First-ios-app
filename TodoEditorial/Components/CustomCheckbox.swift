import SwiftUI

public struct CustomCheckbox: View {
    public var isChecked: Bool
    public var onToggle: () -> Void
    public var activeColor: Color
    public var checkColor: Color
    public var borderColor: Color
    
    public init(
        isChecked: Bool,
        activeColor: Color = AppColor.paper,
        checkColor: Color = AppColor.black,
        borderColor: Color = AppColor.paper,
        onToggle: @escaping () -> Void
    ) {
        self.isChecked = isChecked
        self.activeColor = activeColor
        self.checkColor = checkColor
        self.borderColor = borderColor
        self.onToggle = onToggle
    }
    
    public var body: some View {
        Button(action: {
            onToggle()
        }) {
            ZStack {
                Rectangle()
                    .strokeBorder(isChecked ? activeColor : borderColor, lineWidth: 2)
                    .background(Rectangle().fill(isChecked ? activeColor : Color.clear))
                    .frame(width: 22, height: 22)
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(checkColor)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
