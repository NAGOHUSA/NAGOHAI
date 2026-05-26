import SwiftUI

// MARK: - MessageBubbleView

struct MessageBubbleView: View {
    @EnvironmentObject var appState: AppState
    let message: ChatMessage
    var onSuggestion: ((String) -> Void)? = nil

    var isUser: Bool { message.role == "user" }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if isUser { Spacer(minLength: 48) }

            if !isUser { avatarView }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                bubbleBody

                if let meta = message.metadata {
                    HStack(spacing: 6) {
                        Text("−\(meta.tokensCharged) tokens")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 1)
                            .background(NagohTheme.goldLt)
                            .cornerRadius(8)
                        Text("\(meta.tokensRemaining.formatted()) left")
                    }
                    .font(NagohTheme.sans(10))
                    .foregroundColor(NagohTheme.muted)
                }

                // Suggestion chips (AI only)
                if !isUser, message.metadata != nil {
                    let suggestions = appState.suggestions(for: "")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(suggestions, id: \.self) { sug in
                                Button(action: { onSuggestion?(sug) }) {
                                    Text("↪ \(sug)")
                                        .font(NagohTheme.sans(11))
                                        .foregroundColor(NagohTheme.dim)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(NagohTheme.parchment)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(NagohTheme.border2, lineWidth: 1)
                                        )
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.top, 2)
                }
            }

            if isUser { avatarView }
            if !isUser { Spacer(minLength: 48) }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(isUser ? NagohTheme.warm : NagohTheme.teal)
                .frame(width: 30, height: 30)
            if isUser {
                if let pic = appState.currentUser?.picture,
                   let url = URL(string: pic) {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        userInitial
                    }
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)
                } else {
                    userInitial
                }
            } else {
                Text("N")
                    .font(.custom("Georgia-Bold", size: 13))
                    .foregroundColor(.white)
            }
        }
    }

    private var userInitial: some View {
        Text(appState.currentUser?.name.prefix(1).uppercased() ?? "U")
            .font(NagohTheme.sans(11, weight: .semibold))
            .foregroundColor(NagohTheme.dim)
    }

    @ViewBuilder
    private var bubbleBody: some View {
        if message.content.hasPrefix("⚠️") {
            // Error bubble
            Text(message.content)
                .font(NagohTheme.sans(14))
                .foregroundColor(Color(hex: "b8392e"))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(NagohTheme.roseLt)
                .overlay(
                    RoundedRectangle(cornerRadius: isUser ? 14 : 4, style: .continuous)
                        .stroke(NagohTheme.roseMd, lineWidth: 1)
                )
                .clipShape(bubbleShape)
        } else {
            Text(message.content)
                .font(NagohTheme.sans(15))
                .foregroundColor(isUser ? .white : NagohTheme.ink)
                .lineSpacing(3)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isUser ? NagohTheme.teal : Color.white)
                .clipShape(bubbleShape)
                .overlay(
                    bubbleShape
                        .stroke(isUser ? Color.clear : NagohTheme.border, lineWidth: 1)
                )
                .shadow(color: .black.opacity(isUser ? 0 : 0.04), radius: 4, x: 0, y: 1)
        }
    }

    private var bubbleShape: some Shape {
        isUser
            ? UnevenRoundedRectangle(topLeadingRadius: 14, bottomLeadingRadius: 14, bottomTrailingRadius: 14, topTrailingRadius: 4)
            : UnevenRoundedRectangle(topLeadingRadius: 4, bottomLeadingRadius: 14, bottomTrailingRadius: 14, topTrailingRadius: 14)
    }
}

// MARK: - Thinking bubble

struct ThinkingBubbleView: View {
    @State private var dotOpacity: [Double] = [0.3, 0.3, 0.3]
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    @State private var dotIndex = 0

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack {
                Circle().fill(NagohTheme.teal).frame(width: 30, height: 30)
                Text("N").font(.custom("Georgia-Bold", size: 13)).foregroundColor(.white)
            }
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(NagohTheme.dim)
                        .frame(width: 7, height: 7)
                        .opacity(dotOpacity[i])
                        .scaleEffect(dotOpacity[i] == 1 ? 1.1 : 0.85)
                        .animation(.easeInOut(duration: 0.4), value: dotOpacity[i])
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(NagohTheme.border, lineWidth: 1))
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 4, bottomLeadingRadius: 14, bottomTrailingRadius: 14, topTrailingRadius: 14))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
        .onReceive(timer) { _ in
            dotOpacity = [0.3, 0.3, 0.3]
            dotOpacity[dotIndex] = 1.0
            dotIndex = (dotIndex + 1) % 3
        }
    }
}
