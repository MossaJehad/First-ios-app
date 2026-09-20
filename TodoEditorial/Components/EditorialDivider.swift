import SwiftUI

public struct EditorialDivider: View {
    public var color: Color
    public var height: CGFloat
    
    public init(color: Color = AppColor.darkDivider, height: CGFloat = AppSpacing.hairline) {
        self.color = color
        self.height = height
    }
    
    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
    }
}
