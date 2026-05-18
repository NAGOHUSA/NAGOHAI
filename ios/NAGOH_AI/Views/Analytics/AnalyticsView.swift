import SwiftUI
import Charts

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()

                if viewModel.isLoading && viewModel.data == nil {
                    LoadingView(message: "📡 Loading analytics data…")
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            headerSection

                            if let error = viewModel.errorMessage {
                                ErrorBanner(message: error) {
                                    viewModel.errorMessage = nil
                                }
                            }

                            if let data = viewModel.data {
                                metricCards(data: data)
                                chartsSection(data: data)
                                breakdownTable(data: data)
                                insightsPanel(data: data)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.loadData() }
        }
    }

    // MARK: – Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Demo toggle
            Toggle(isOn: $viewModel.isDemoMode) {
                HStack(spacing: 6) {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.nagohGold)
                    Text("Demo Data")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.nagohInk)
                }
            }
            .tint(.nagohGold)
            .padding(12)
            .background(Color.nagohGoldLt)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.nagohGold.opacity(0.3), lineWidth: 1))

            // Period selector
            HStack(spacing: 8) {
                ForEach(AnalyticsPeriod.allCases) { period in
                    Button(action: { viewModel.period = period }) {
                        Text(period.displayName)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(viewModel.period == period ? Color.nagohTeal : Color.white)
                            .foregroundColor(viewModel.period == period ? .white : .nagohInk)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.period == period ? Color.clear : Color.nagohBorder, lineWidth: 1)
                            )
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: – Metric Cards

    private func metricCards(data: AnalyticsData) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MetricCard(
                emoji: "✍️",
                value: "\(data.totalContent)",
                label: "Pieces Created",
                explanation: "How much content you've generated. More content = more audience touch points."
            )
            MetricCard(
                emoji: "💬",
                value: "\(data.avgEngagement)%",
                label: "Avg Engagement",
                explanation: "Average engagement per piece. Higher % means your content resonates."
            )
            MetricCard(
                emoji: "🎯",
                value: data.bestFormat,
                label: "Best Performing",
                explanation: "Your most effective content type. Focus more on what works best."
            )
            MetricCard(
                emoji: "⏱️",
                value: data.avgCreationTime,
                label: "Avg Create Time",
                explanation: "How long it takes to create content. AI helps you create faster."
            )
        }
        .padding(.horizontal, 16)
    }

    // MARK: – Charts

    @ViewBuilder
    private func chartsSection(data: AnalyticsData) -> some View {
        VStack(spacing: 16) {
            // 1. Daily Trend
            chartCard(title: "📅 Daily Content Trend") {
                if #available(iOS 16.0, *) {
                    Chart {
                        ForEach(Array(zip(data.trendLabels, data.trendData)), id: \.0) { label, value in
                            LineMark(
                                x: .value("Day", label),
                                y: .value("Count", value)
                            )
                            .foregroundStyle(Color.nagohTeal)
                            .interpolationMethod(.catmullRom)
                            AreaMark(
                                x: .value("Day", label),
                                y: .value("Count", value)
                            )
                            .foregroundStyle(Color.nagohTeal.opacity(0.15))
                            .interpolationMethod(.catmullRom)
                        }
                    }
                    .frame(height: 160)
                    .chartXAxis {
                        AxisMarks(values: .automatic) { _ in
                            AxisValueLabel().font(.system(size: 10))
                        }
                    }
                } else {
                    simpleBarFallback(labels: data.trendLabels, values: data.trendData, color: .nagohTeal)
                }
            }

            // 2. Engagement by Format
            chartCard(title: "💬 Engagement by Format") {
                if #available(iOS 16.0, *) {
                    Chart {
                        ForEach(Array(zip(data.engagementLabels, data.engagementData)), id: \.0) { label, value in
                            BarMark(
                                x: .value("Format", label),
                                y: .value("Engagement %", value)
                            )
                            .foregroundStyle(Color.nagohGold)
                            .cornerRadius(4)
                        }
                    }
                    .frame(height: 160)
                } else {
                    simpleBarFallback(labels: data.engagementLabels, values: data.engagementData, color: .nagohGold)
                }
            }

            // 3. Editing Sessions
            chartCard(title: "✏️ Editing Sessions") {
                if #available(iOS 16.0, *) {
                    Chart {
                        ForEach(Array(zip(data.editingLabels, data.editingData)), id: \.0) { label, value in
                            BarMark(
                                x: .value("Edits", label),
                                y: .value("Count", value)
                            )
                            .foregroundStyle(Color.nagohTeal)
                            .cornerRadius(4)
                        }
                    }
                    .frame(height: 160)
                } else {
                    simpleBarFallback(labels: data.editingLabels, values: data.editingData, color: .nagohTeal)
                }
            }

            // 4. Topic Distribution
            chartCard(title: "🏷️ Topic Distribution") {
                if #available(iOS 16.0, *) {
                    Chart {
                        ForEach(Array(zip(data.topicLabels, data.topicData)), id: \.0) { label, value in
                            SectorMark(
                                angle: .value("Count", value),
                                innerRadius: .ratio(0.5),
                                angularInset: 1.5
                            )
                            .foregroundStyle(by: .value("Topic", label))
                            .cornerRadius(4)
                        }
                    }
                    .frame(height: 200)
                    .chartLegend(position: .trailing)
                } else {
                    simpleBarFallback(labels: data.topicLabels, values: data.topicData, color: .nagohPlum)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func chartCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.nagohInk)
            content()
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
    }

    private func simpleBarFallback(labels: [String], values: [Int], color: Color) -> some View {
        let maxVal = values.max() ?? 1
        return HStack(alignment: .bottom, spacing: 6) {
            ForEach(Array(zip(labels, values)), id: \.0) { label, value in
                VStack(spacing: 4) {
                    Text("\(value)")
                        .font(.system(size: 9))
                        .foregroundColor(.nagohDim)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(height: CGFloat(value) / CGFloat(maxVal) * 80 + 4)
                    Text(label)
                        .font(.system(size: 9))
                        .foregroundColor(.nagohDim)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 120)
    }

    // MARK: – Breakdown Table

    private func breakdownTable(data: AnalyticsData) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 Content Breakdown")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.nagohInk)

            VStack(spacing: 0) {
                // Header row
                HStack {
                    Text("Type").frame(maxWidth: .infinity, alignment: .leading)
                    Text("Count").frame(width: 48, alignment: .trailing)
                    Text("Edits").frame(width: 48, alignment: .trailing)
                    Text("Eng%").frame(width: 48, alignment: .trailing)
                    Text("Exports").frame(width: 56, alignment: .trailing)
                }
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.nagohDim)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.nagohWarm)

                ForEach(data.breakdown) { row in
                    HStack {
                        Text(row.type).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(row.count)").frame(width: 48, alignment: .trailing)
                        Text("\(row.edits)").frame(width: 48, alignment: .trailing)
                        Text("\(row.engagement)%").frame(width: 48, alignment: .trailing)
                        Text("\(row.exports)").frame(width: 56, alignment: .trailing)
                    }
                    .font(.subheadline)
                    .foregroundColor(.nagohInk)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)

                    Divider().background(Color.nagohBorder)
                }
            }
            .background(Color.cardBg)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
        }
        .padding(.horizontal, 16)
    }

    // MARK: – Quick Insights

    private func insightsPanel(data: AnalyticsData) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💡 Quick Insights")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.nagohInk)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(data.insights, id: \.self) { insight in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.nagohTeal)
                            .font(.subheadline)
                        Text(insight)
                            .font(.subheadline)
                            .foregroundColor(.nagohInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(16)
            .background(Color.nagohTealLt)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohTeal.opacity(0.2), lineWidth: 1))
        }
        .padding(.horizontal, 16)
    }
}
