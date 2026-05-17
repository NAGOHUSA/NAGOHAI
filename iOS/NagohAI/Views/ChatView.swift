import SwiftUI

// MARK: - ChatView

struct ChatView: View {
    @EnvironmentObject var appState: AppState
    @State private var inputText    = ""
    @State private var showSidebar  = false
    @State private var showSettings = false
    @State private var showUpgrade  = false
    @FocusState private var inputFocused: Bool

    private var industry: IndustryConfig? { INDUSTRIES[appState.currentIndustry] }

    var body: some View {
        ZStack(alignment: .bottom) {
            NagohTheme.cream.ignoresSafeArea()

            VStack(spacing: 0) {
                topbar
                Divider().background(NagohTheme.border)
                messagesArea
                inputBar
            }

            // Success banner
            if let msg = appState.successMessage {
                successBanner(msg)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.successMessage)
        .sheet(isPresented: $showSidebar) {
            SidebarSheet(inputText: $inputText, onDismiss: { showSidebar = false })
                .environmentObject(appState)
        }
        .sheet(isPresented: $showSettings) {
            SettingsSheet(inputText: $inputText, onDismiss: { showSettings = false })
                .environmentObject(appState)
        }
        .sheet(isPresented: $showUpgrade) {
            UpgradeView(onDismiss: { showUpgrade = false })
                .environmentObject(appState)
        }
        .onChange(of: appState.showUpgrade) { val in showUpgrade = val }
        .task { await appState.refreshBalance() }
    }

    // MARK: - Topbar

    private var topbar: some View {
        HStack(spacing: 8) {
            // Sidebar / menu button
            Button(action: { showSidebar = true }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }

            // Wordmark
            VStack(alignment: .leading, spacing: 0) {
                (Text("NAGOH ").font(.custom("Georgia-Bold", size: 16)).foregroundColor(.white)
                + Text("AI").font(.custom("Georgia-BoldItalic", size: 16)).foregroundColor(NagohTheme.gold))
                Text("YOUR BUSINESS ASSISTANT")
                    .font(NagohTheme.sans(8, weight: .light))
                    .foregroundColor(.white.opacity(0.45))
                    .kerning(1.2)
            }

            Spacer()

            // Token balance
            VStack(alignment: .trailing, spacing: 0) {
                Text(appState.balance.formatted())
                    .font(NagohTheme.sans(12, weight: .medium))
                    .foregroundColor(NagohTheme.goldMd)
                Text("tokens")
                    .font(NagohTheme.sans(9))
                    .foregroundColor(.white.opacity(0.4))
            }

            // Connection indicator
            connectionDot

            // Settings
            Button(action: { showSettings = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
            }

            // User avatar
            if let pic = appState.currentUser?.picture,
               let url = URL(string: pic) {
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(NagohTheme.warm)
                }
                .frame(width: 28, height: 28)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: 1.5))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(NagohTheme.deep)
        .overlay(alignment: .bottom) {
            Rectangle().frame(height: 3).foregroundColor(NagohTheme.rose)
        }
    }

    private var connectionDot: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(dotColor)
                .frame(width: 6, height: 6)
                .opacity(appState.connectionStatus == .connecting ? 0.5 : 1)
                .animation(
                    appState.connectionStatus == .connecting
                    ? .easeInOut(duration: 0.8).repeatForever() : .default,
                    value: appState.connectionStatus == .connecting
                )
        }
    }

    private var dotColor: Color {
        switch appState.connectionStatus {
        case .connected:  return NagohTheme.sage
        case .error:      return NagohTheme.rose
        case .connecting: return NagohTheme.gold
        case .idle:       return NagohTheme.muted
        }
    }

    // MARK: - Messages area

    private var messagesArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    if appState.messages.isEmpty {
                        emptyState
                    } else {
                        ForEach(appState.messages) { msg in
                            MessageBubbleView(message: msg, onSuggestion: { sug in
                                inputText = sug
                                inputFocused = true
                            })
                            .id(msg.id)
                        }

                        if appState.isBusy {
                            ThinkingBubbleView()
                                .id("thinking")
                        }

                        // Scroll anchor
                        Color.clear.frame(height: 12).id("bottom")
                    }
                }
                .padding(.vertical, 12)
            }
            .onChange(of: appState.messages.count) { _ in
                withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
            }
            .onChange(of: appState.isBusy) { _ in
                withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
            }
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 60)

            (Text("Your AI ")
                .font(.custom("Georgia", size: 28))
                .foregroundColor(NagohTheme.ink)
            + Text("business partner")
                .font(.custom("Georgia-Italic", size: 28))
                .foregroundColor(NagohTheme.teal)
            + Text("\nis ready to help.")
                .font(.custom("Georgia", size: 28))
                .foregroundColor(NagohTheme.ink)
            )
            .multilineTextAlignment(.center)
            .lineSpacing(2)

            Text(industry?.emptyMsg ?? "Your AI assistant for all small business needs.")
                .font(NagohTheme.sans(13))
                .foregroundColor(NagohTheme.dim)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 32)

            // Quick chip starters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(industry?.quickStarters.prefix(4) ?? []) { starter in
                        Button(action: { inputText = starter.prompt; inputFocused = true }) {
                            HStack(spacing: 6) {
                                Text(starter.emoji).font(.system(size: 14))
                                Text(starter.title)
                                    .font(NagohTheme.sans(12, weight: .medium))
                                    .foregroundColor(NagohTheme.sub)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(NagohTheme.border, lineWidth: 1)
                            )
                            .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            Text("Use quick starters or type your question below")
                .font(NagohTheme.sans(10))
                .foregroundColor(NagohTheme.muted)
                .kerning(0.8)
                .textCase(.uppercase)
                .padding(.top, 4)

            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    // MARK: - Input bar

    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider().background(NagohTheme.border)

            HStack(alignment: .bottom, spacing: 8) {
                // Text input
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(inputFocused ? NagohTheme.teal : NagohTheme.border2, lineWidth: 1.5)
                        )

                    if inputText.isEmpty {
                        Text(industry?.placeholder ?? "Ask anything…")
                            .font(NagohTheme.sans(15))
                            .foregroundColor(NagohTheme.muted)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .allowsHitTesting(false)
                    }

                    TextEditor(text: $inputText)
                        .font(NagohTheme.sans(15))
                        .foregroundColor(NagohTheme.ink)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .focused($inputFocused)
                        .frame(minHeight: 44, maxHeight: 120)
                }
                .frame(minHeight: 44)

                // Send button
                Button(action: sendMessage) {
                    Text("Send ↑")
                        .font(NagohTheme.sans(13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(
                            (inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || appState.isBusy)
                            ? NagohTheme.teal.opacity(0.3) : NagohTheme.teal
                        )
                        .cornerRadius(12)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || appState.isBusy)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(NagohTheme.parchment)

            // Footer hint
            HStack {
                Text("Tap Send or Return to send  ·  ")
                    .font(NagohTheme.sans(10))
                    .foregroundColor(NagohTheme.muted)
                Text(industry?.name ?? "")
                    .font(NagohTheme.sans(10, weight: .medium))
                    .foregroundColor(NagohTheme.dim)
                Spacer()
                if !inputText.isEmpty {
                    Text("\(inputText.count) chars")
                        .font(NagohTheme.sans(10))
                        .foregroundColor(NagohTheme.muted)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .background(NagohTheme.parchment)
        }
    }

    // MARK: - Success Banner

    private func successBanner(_ msg: String) -> some View {
        HStack(spacing: 10) {
            Text(msg)
                .font(NagohTheme.sans(13))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(NagohTheme.sage)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
        .padding(.bottom, 100)
    }

    // MARK: - Actions

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        inputFocused = false
        Task { await appState.sendMessage(text) }
    }
}

#Preview {
    ChatView().environmentObject(AppState())
}
