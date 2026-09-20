import SwiftUI

public struct MenuView: View {
    @Binding var currentScreen: AppScreen
    @Binding var isPresented: Bool
    
    public init(currentScreen: Binding<AppScreen>, isPresented: Binding<Bool>) {
        self._currentScreen = currentScreen
        self._isPresented = isPresented
    }
    
    public var body: some View {
        ResponsiveContainer { metrics in
            VStack(alignment: .leading, spacing: 0) {
                // Top Header
                EditorialHeader(
                    title: "FOCUS",
                    rightText: "CLOSE",
                    titleColor: AppColor.red,
                    rightColor: AppColor.paper,
                    onRightTap: {
                        isPresented = false
                    }
                )
                
                Spacer(minLength: metrics.isCompact ? 8 : 18)
                
                // Section Title
                VStack(alignment: .leading, spacing: 4) {
                    Text("NAVIGATION")
                        .font(AppFont.caption(12, bold: true))
                        .tracking(2.5)
                        .foregroundStyle(AppColor.mutedGray)
                }
                .padding(.horizontal, metrics.horizontalMargin)
                .padding(.bottom, metrics.isCompact ? 10 : 16)
                
                EditorialDivider(color: AppColor.darkDivider)
                
                // Giant Typography Menu Links
                VStack(spacing: 0) {
                    ForEach(AppScreen.allCases) { screen in
                        Button(action: {
                            AppHaptics.buttonTap()
                            currentScreen = screen
                            isPresented = false
                        }) {
                            HStack(alignment: .center, spacing: AppSpacing.md) {
                                Text(screen.indexString)
                                    .font(AppFont.section(metrics.isCompact ? 22 : 28))
                                    .foregroundStyle(currentScreen == screen ? AppColor.orange : AppColor.mutedGray)
                                    .frame(width: metrics.isCompact ? 36 : 44, alignment: .leading)
                                
                                Text(screen.rawValue)
                                    .font(AppFont.hero(metrics.isCompact ? 42 : 52))
                                    .foregroundStyle(currentScreen == screen ? AppColor.orange : AppColor.paper)
                                    .tracking(0.5)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                Spacer()
                                
                                if currentScreen == screen {
                                    Text("●")
                                        .font(.system(size: 14))
                                        .foregroundStyle(AppColor.orange)
                                } else {
                                    Text("→")
                                        .font(AppFont.section(metrics.isCompact ? 22 : 26))
                                        .foregroundStyle(AppColor.mutedGray.opacity(0.4))
                                }
                            }
                            .padding(.horizontal, metrics.horizontalMargin)
                            .padding(.vertical, metrics.isCompact ? 12 : 16)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        EditorialDivider(color: AppColor.darkDivider)
                    }
                }
                
                Spacer(minLength: 16)
                
                // Editorial Footer anchored naturally at the bottom
                VStack(alignment: .leading, spacing: 6) {
                    EditorialDivider(color: AppColor.darkDivider)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("SWISS / EDITORIAL BRUTALISM")
                            .font(AppFont.caption(10, bold: true))
                            .tracking(1.5)
                            .foregroundStyle(AppColor.mutedGray)
                        
                        Spacer()
                        
                        Text("V 1.0")
                            .font(AppFont.mono(10, bold: true))
                            .foregroundStyle(AppColor.mutedGray)
                    }
                    .padding(.horizontal, metrics.horizontalMargin)
                    .padding(.bottom, metrics.isCompact ? 16 : 24)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.black.ignoresSafeArea())
        }
    }
}
