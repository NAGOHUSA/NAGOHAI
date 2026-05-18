import SwiftUI

// MARK: – Metric Card

struct MetricCard: View {
    let emoji: String
    let value: String
    let label: String
    let explanation: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundColor(.nagohTeal)
                    Text(label)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.nagohMuted)
                        .textCase(.uppercase)
                        .kerning(0.5)
                }
                Spacer()
                Text(emoji)
                    .font(.title)
            }
            .padding(.bottom, 12)

            Divider()
                .background(Color.nagohBorder)
                .padding(.bottom, 8)

            Text(explanation)
                .font(.caption)
                .foregroundColor(.nagohDim)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.nagohBorder, lineWidth: 1)
        )
    }
}

// MARK: – Loading View

struct LoadingView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .nagohTeal))
                .scaleEffect(1.2)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.nagohDim)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

// MARK: – Error Banner

struct ErrorBanner: View {
    let message: String
    var onDismiss: (() -> Void)?

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.nagohRose)
            Text(message)
                .font(.caption)
                .foregroundColor(.nagohInk)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(.nagohDim)
                        .font(.caption)
                }
            }
        }
        .padding(12)
        .background(Color.nagohRoseLt)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.nagohRose.opacity(0.3), lineWidth: 1))
        .padding(.horizontal, 16)
    }
}

// MARK: – Primary Button

struct NagohButton: View {
    let title: String
    let icon: String?
    var isLoading: Bool = false
    var style: ButtonStyle = .teal
    let action: () -> Void

    enum ButtonStyle {
        case teal, gold, outline
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                } else if let icon {
                    Image(systemName: icon)
                        .font(.subheadline.weight(.semibold))
                }
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(borderOverlay)
        }
        .disabled(isLoading)
    }

    private var foregroundColor: Color {
        switch style {
        case .teal, .gold: return .white
        case .outline: return .nagohTeal
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .teal:    return .nagohTeal
        case .gold:    return .nagohGold
        case .outline: return .clear
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outline {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.nagohTeal, lineWidth: 1.5)
        }
    }
}

// MARK: – Tag / Badge

struct MomentumBadge: View {
    let momentum: Momentum

    var body: some View {
        Text(momentum.badge)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(momentum.color.foreground)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(momentum.color.background)
            .cornerRadius(6)
    }
}

// MARK: – Industry Picker Row

struct IndustryPickerRow: View {
    @Binding var selectedIndustry: Industry

    var body: some View {
        Menu {
            ForEach(Industry.allCases) { industry in
                Button(action: { selectedIndustry = industry }) {
                    Label(industry.displayName, systemImage: selectedIndustry == industry ? "checkmark" : "")
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text(selectedIndustry.emoji)
                Text(selectedIndustry.displayName)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.nagohInk)
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.nagohDim)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.nagohWarm)
            .cornerRadius(8)
        }
    }
}
