import SwiftUI

struct TrendingView: View {
    @StateObject private var viewModel = TrendingViewModel()
    @EnvironmentObject private var chatViewModel: ChatViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()

                if viewModel.isLoading && viewModel.topics.isEmpty {
                    LoadingView(message: "📡 Finding trending topics…")
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {

                            // Industry selector
                            industrySelector

                            // Error
                            if let error = viewModel.errorMessage {
                                ErrorBanner(message: error) { viewModel.errorMessage = nil }
                                    .padding(.horizontal, 0)
                            }

                            // Topics
                            topicsSection

                            // How to use
                            howToUseCard

                            // Momentum legend
                            momentumLegend
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Trending Topics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { Task { await viewModel.refresh() } }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.nagohTeal)
                    }
                }
            }
            .task { await viewModel.loadTopics() }
        }
    }

    // MARK: – Industry selector

    private var industrySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Industry.allCases) { industry in
                    Button(action: { viewModel.changeIndustry(industry) }) {
                        HStack(spacing: 4) {
                            Text(industry.emoji)
                            Text(industry.displayName.components(separatedBy: " ").dropFirst().joined(separator: " "))
                                .font(.caption.weight(.medium))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(viewModel.selectedIndustry == industry ? Color.nagohTeal : Color.white)
                        .foregroundColor(viewModel.selectedIndustry == industry ? .white : .nagohInk)
                        .cornerRadius(20)
                        .overlay(
                            Capsule().stroke(
                                viewModel.selectedIndustry == industry ? Color.clear : Color.nagohBorder,
                                lineWidth: 1
                            )
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: – Topics

    private var topicsSection: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.topics) { topic in
                topicCard(topic)
            }
        }
        .padding(.horizontal, 16)
    }

    private func topicCard(_ topic: TrendingTopic) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(topic.emoji)
                            .font(.title3)
                        Text(topic.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.nagohInk)
                    }
                    MomentumBadge(momentum: topic.momentum)
                }
                Spacer()
                // Add to chat
                Button(action: {
                    let prompt = "Topic: \(topic.title) \(topic.emoji)\n\nContext: \(topic.context)\n\nHelp me create 3 variations of content about this topic optimized for my audience."
                    chatViewModel.inputText = prompt
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add to Chat")
                            .font(.caption.weight(.medium))
                    }
                    .foregroundColor(.nagohTeal)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.nagohTealLt)
                    .cornerRadius(8)
                }
            }

            Text(topic.context)
                .font(.subheadline)
                .foregroundColor(.nagohDim)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
    }

    // MARK: – How to use card

    private var howToUseCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("💡 How to Use These Topics")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.nagohInk)

            VStack(alignment: .leading, spacing: 8) {
                tipRow("Pick a topic and tap \"Add to Chat\" to create variations instantly")
                tipRow("Stay seasonal — notice which topics relate to current events")
                tipRow("Mix formats — turn trending ideas into posts, emails, videos, or guides")
                tipRow("Refresh daily — topics update with fresh AI insights every day")
            }
        }
        .padding(16)
        .background(Color.nagohGoldLt)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohGold.opacity(0.3), lineWidth: 1))
        .padding(.horizontal, 16)
    }

    private func tipRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.nagohGold)
                .fontWeight(.bold)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.nagohInk)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: – Momentum legend

    private var momentumLegend: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 Understanding Momentum")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.nagohInk)

            HStack(spacing: 10) {
                legendBadge(
                    badge: "🚀 TRENDING",
                    description: "Hot right now — peak attention. Jump on this quickly.",
                    color: .nagohGoldLt,
                    border: .nagohGold
                )
                legendBadge(
                    badge: "📈 STEADY",
                    description: "Reliable interest — always works. Safe bet.",
                    color: .nagohTealLt,
                    border: .nagohTeal
                )
                legendBadge(
                    badge: "♾️ EVERGREEN",
                    description: "Timeless — relevant year-round. Build a library.",
                    color: .nagohPlumLt,
                    border: .nagohPlum
                )
            }
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    private func legendBadge(badge: String, description: String, color: Color, border: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(badge)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(border)
            Text(description)
                .font(.system(size: 10))
                .foregroundColor(.nagohInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(border.opacity(0.4), lineWidth: 2)
        )
    }
}
