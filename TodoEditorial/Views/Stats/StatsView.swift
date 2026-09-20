import SwiftUI
import SwiftData

public struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allTasks: [TodoTask]
    @Binding var isMenuPresented: Bool
    public var onKeepGoingTap: () -> Void
    
    public init(isMenuPresented: Binding<Bool>, onKeepGoingTap: @escaping () -> Void) {
        self._isMenuPresented = isMenuPresented
        self.onKeepGoingTap = onKeepGoingTap
    }
    
    private var completedCount: Int {
        allTasks.filter { $0.isCompleted }.count
    }
    
    private var pendingCount: Int {
        allTasks.filter { !$0.isCompleted }.count
    }
    
    private var completionRate: Int {
        guard !allTasks.isEmpty else { return 86 }
        let rate = Double(completedCount) / Double(allTasks.count) * 100
        return Int(rate)
    }
    
    private let weekDays: [String] = ["M", "T", "W", "T", "F"]
    private let sampleValues: [CGFloat] = [0.45, 0.65, 0.75, 0.90, 0.82]
    
    public var body: some View {
        ResponsiveContainer { metrics in
            VStack(spacing: 0) {
                // Top Editorial Header
                EditorialHeader(
                    title: "FOCUS",
                    rightText: "MENU",
                    titleColor: AppColor.black,
                    rightColor: AppColor.black,
                    onRightTap: {
                        isMenuPresented = true
                    }
                )
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Giant Hero Stats Heading
                        VStack(alignment: .leading, spacing: -6) {
                            Text("FOCUS")
                                .font(AppFont.hero(metrics.displayFontSize))
                            Text("\(completionRate)")
                                .font(AppFont.hero(metrics.heroNumberFontSize))
                        }
                        .foregroundStyle(AppColor.black)
                        .padding(.horizontal, metrics.horizontalMargin)
                        .padding(.top, 2)
                        
                        Text("SCORE / 100")
                            .font(AppFont.caption(11, bold: true))
                            .tracking(2.0)
                            .foregroundStyle(AppColor.black)
                            .padding(.horizontal, metrics.horizontalMargin)
                            .padding(.bottom, metrics.isCompact ? 8 : 12)
                        
                        EditorialDivider(color: AppColor.lightDivider)
                        
                        // Minimalist Line Chart
                        minimalistLineChart
                            .frame(height: metrics.isCompact ? 70 : 85)
                            .padding(.horizontal, metrics.horizontalMargin)
                            .padding(.vertical, metrics.isCompact ? 10 : 14)
                        
                        EditorialDivider(color: AppColor.lightDivider)
                        
                        // Stats Table
                        VStack(spacing: 0) {
                            statRow(label: "COMPLETED", value: String(format: "%02d", completedCount), margin: metrics.horizontalMargin, isCompact: metrics.isCompact)
                            EditorialDivider(color: AppColor.lightDivider)
                            
                            statRow(label: "PENDING", value: String(format: "%02d", pendingCount), margin: metrics.horizontalMargin, isCompact: metrics.isCompact)
                            EditorialDivider(color: AppColor.lightDivider)
                            
                            statRow(label: "FOCUS TIME", value: "3H 20", margin: metrics.horizontalMargin, isCompact: metrics.isCompact)
                            EditorialDivider(color: AppColor.lightDivider)
                            
                            statRow(label: "STREAK", value: "12", margin: metrics.horizontalMargin, isCompact: metrics.isCompact)
                            EditorialDivider(color: AppColor.lightDivider)
                        }
                        
                        Spacer(minLength: 16)
                    }
                }
            }
            .background(AppColor.paper.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) {
                bottomAgainBlock(metrics: metrics)
            }
        }
    }
    
    private func statRow(label: String, value: String, margin: CGFloat, isCompact: Bool) -> some View {
        HStack {
            Text(label)
                .font(AppFont.caption(11, bold: true))
                .tracking(2.0)
                .foregroundStyle(AppColor.black)
            
            Spacer()
            
            Text(value)
                .font(AppFont.section(isCompact ? 18 : 20))
                .foregroundStyle(AppColor.black)
        }
        .padding(.horizontal, margin)
        .padding(.vertical, isCompact ? 8 : 10)
    }
    
    // Minimalist Line Chart that adapts smoothly to container width with safe insets
    private var minimalistLineChart: some View {
        GeometryReader { geo in
            let count = weekDays.count
            let chartHeight = geo.size.height - 20
            let insetX: CGFloat = 16
            let usableWidth = max(10, geo.size.width - (insetX * 2))
            let stepX = usableWidth / CGFloat(count - 1)
            
            ZStack {
                // Horizontal baseline
                Path { path in
                    path.move(to: CGPoint(x: insetX, y: chartHeight))
                    path.addLine(to: CGPoint(x: geo.size.width - insetX, y: chartHeight))
                }
                .stroke(AppColor.black, lineWidth: 1)
                
                // Vertical drop lines and Day labels
                ForEach(0..<count, id: \.self) { i in
                    let x = insetX + CGFloat(i) * stepX
                    let val = sampleValues[i]
                    let y = chartHeight * (1.0 - val * 0.78)
                    
                    // Hairline vertical drop line
                    Path { path in
                        path.move(to: CGPoint(x: x, y: y))
                        path.addLine(to: CGPoint(x: x, y: chartHeight))
                    }
                    .stroke(AppColor.black.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                    
                    // Day label below baseline
                    Text(weekDays[i])
                        .font(AppFont.caption(11, bold: true))
                        .foregroundStyle(AppColor.black)
                        .position(x: x, y: chartHeight + 12)
                }
                
                // Connecting trend line
                Path { path in
                    for i in 0..<count {
                        let x = insetX + CGFloat(i) * stepX
                        let val = sampleValues[i]
                        let y = chartHeight * (1.0 - val * 0.78)
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(AppColor.black, lineWidth: 1.8)
                
                // Circular points on data nodes
                ForEach(0..<count, id: \.self) { i in
                    let x = insetX + CGFloat(i) * stepX
                    let val = sampleValues[i]
                    let y = chartHeight * (1.0 - val * 0.78)
                    
                    Circle()
                        .fill(AppColor.black)
                        .frame(width: 5, height: 5)
                        .position(x: x, y: y)
                }
            }
        }
    }
    
    // Bottom Orange Section with massive "AGAIN" or "KEEP GOING"
    private func bottomAgainBlock(metrics: ResponsiveMetrics) -> some View {
        Button(action: {
            AppHaptics.buttonTap()
            onKeepGoingTap()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                Text("AGAIN")
                    .font(AppFont.hero(metrics.isCompact ? 68 : 84))
                    .foregroundStyle(AppColor.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, metrics.horizontalMargin)
                    .padding(.top, 2)
                
                HStack {
                    Text("REPEAT SESSION")
                        .font(AppFont.caption(11, bold: true))
                        .tracking(2.0)
                        .foregroundStyle(AppColor.black)
                    
                    Spacer()
                    
                    Text("→")
                        .font(AppFont.section(metrics.isCompact ? 20 : 24))
                        .foregroundStyle(AppColor.black)
                }
                .padding(.horizontal, metrics.horizontalMargin)
                .padding(.bottom, metrics.isCompact ? 12 : 18)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColor.orange)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
