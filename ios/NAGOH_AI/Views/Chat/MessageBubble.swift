import SwiftUI

// MARK: – MessageBubble

struct MessageBubble: View {
    let message: ChatMessage

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 60) }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                if message.isLoading {
                    loadingBubble
                } else {
                    contentBubble
                }

                HStack(spacing: 6) {
                    if let ct = message.contentType, !isUser {
                        Text(ct.emoji)
                            .font(.system(size: 10))
                        Text(ct.displayName.replacingOccurrences(of: ct.emoji + " ", with: ""))
                            .font(.system(size: 10))
                            .foregroundColor(.nagohMuted)
                    }
                    if let tokens = message.tokensUsed, !isUser {
                        Text("·")
                            .foregroundColor(.nagohMuted)
                            .font(.system(size: 10))
                        Text("\(tokens) tokens")
                            .font(.system(size: 10))
                            .foregroundColor(.nagohMuted)
                    }
                    Text(message.timestamp, style: .time)
                        .font(.system(size: 10))
                        .foregroundColor(.nagohMuted)
                }
            }

            if !isUser { Spacer(minLength: 60) }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }

    private var contentBubble: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(message.content)
                .font(.subheadline)
                .foregroundColor(isUser ? .white : .nagohInk)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)

            // Copy button for assistant messages
            if !isUser {
                HStack {
                    Spacer()
                    Button(action: {
                        UIPasteboard.general.string = message.content
                    }) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 11))
                            .foregroundColor(.nagohDim)
                    }
                    .padding(.top, 6)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(isUser ? Color.nagohTeal : Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isUser ? Color.clear : Color.nagohBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }

    private var loadingBubble: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundColor(.nagohTeal.opacity(0.6))
                    .animation(
                        Animation.easeInOut(duration: 0.5).repeatForever().delay(Double(i) * 0.15),
                        value: true
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.nagohBorder, lineWidth: 1))
    }
}

// MARK: – Quick Starter Card

struct QuickStarterCard: View {
    let starter: QuickStarter
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(starter.emoji)
                    .font(.title2)
                Text(starter.title)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.nagohInk)
                    .lineLimit(1)
                Text(starter.description)
                    .font(.system(size: 10))
                    .foregroundColor(.nagohDim)
                    .lineLimit(2)
            }
            .frame(width: 100, alignment: .leading)
            .padding(10)
            .background(Color.nagohParchmt)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.nagohBorder, lineWidth: 1))
        }
    }
}
