import SwiftUI

// MARK: - SidebarSheet

struct SidebarSheet: View {
    @EnvironmentObject var appState: AppState
    @Binding var inputText: String
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Token Balance
                    balanceSection

                    Divider().background(NagohTheme.border)

                    // Industry selector
                    industrySection

                    Divider().background(NagohTheme.border)

                    // Quick Starters
                    quickStarterSection

                    Divider().background(NagohTheme.border)

                    // Chat actions
                    chatActionsSection

                    Divider().background(NagohTheme.border)

                    // Chat history
                    historySection
                }
            }
            .background(NagohTheme.parchment)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("NAGOH \u{200B}")
                        .font(.custom("Georgia-Bold", size: 16))
                        .foregroundColor(NagohTheme.ink)
                    + Text("AI")
                        .font(.custom("Georgia-BoldItalic", size: 16))
                        .foregroundColor(NagohTheme.gold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: onDismiss)
                        .font(NagohTheme.sans(14, weight: .medium))
                        .foregroundColor(NagohTheme.teal)
                }
            }
        }
    }

    // MARK: - Balance Section

    private var balanceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            label("Your Balance")

            HStack(spacing: 10) {
                Text("🪙").font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.balance.formatted())
                        .font(.custom("Georgia-Bold", size: 20))
                        .foregroundColor(NagohTheme.ink)
                    Text("NAGOH TOKENS")
                        .font(NagohTheme.sans(9, weight: .regular))
                        .foregroundColor(NagohTheme.dim)
                        .kerning(0.8)
                }
                Spacer()
            }
            .padding(12)
            .background(NagohTheme.goldLt)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(NagohTheme.goldMd, lineWidth: 1))
            .cornerRadius(10)

            Button(action: { appState.showUpgrade = true; onDismiss() }) {
                Text("+ Buy More Tokens")
                    .font(NagohTheme.sans(12, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(NagohTheme.gold)
                    .foregroundColor(NagohTheme.deep)
                    .cornerRadius(8)
            }

            if appState.isGuest {
                HStack(spacing: 6) {
                    Text("👤").font(.system(size: 12))
                    Text("Guest mode  ·  ")
                        .font(NagohTheme.sans(11))
                        .foregroundColor(NagohTheme.dim)
                    Button("Sign in for more") {
                        appState.signOut()
                        onDismiss()
                    }
                    .font(NagohTheme.sans(11, weight: .medium))
                    .foregroundColor(NagohTheme.teal)
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(16)
    }

    // MARK: - Industry Section

    private var industrySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            label("Your Industry")

            Picker("Industry", selection: $appState.currentIndustry) {
                ForEach(Industry.allCases) { ind in
                    Text(INDUSTRIES[ind]?.name ?? ind.rawValue)
                        .tag(ind)
                }
            }
            .pickerStyle(.menu)
            .tint(NagohTheme.teal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(NagohTheme.border2, lineWidth: 1.5))
            .cornerRadius(8)
            .onChange(of: appState.currentIndustry) { _ in appState.saveSettings() }

            Text(INDUSTRIES[appState.currentIndustry]?.name ?? "")
                .font(NagohTheme.sans(11, weight: .semibold))
                .foregroundColor(NagohTheme.teal)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(NagohTheme.tealLt)
                .cornerRadius(10)
        }
        .padding(16)
    }

    // MARK: - Quick Starters

    private var quickStarterSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            label("Quick Starters")

            ForEach(INDUSTRIES[appState.currentIndustry]?.quickStarters ?? []) { starter in
                Button(action: {
                    inputText = starter.prompt
                    onDismiss()
                }) {
                    HStack(alignment: .top, spacing: 8) {
                        Text(starter.emoji).font(.system(size: 16))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(starter.title)
                                .font(NagohTheme.sans(13, weight: .medium))
                                .foregroundColor(NagohTheme.ink)
                            Text(starter.desc)
                                .font(NagohTheme.sans(11))
                                .foregroundColor(NagohTheme.dim)
                        }
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                            .foregroundColor(NagohTheme.muted)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(NagohTheme.border, lineWidth: 1))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
    }

    // MARK: - Chat Actions

    private var chatActionsSection: some View {
        VStack(spacing: 6) {
            Button(action: {
                appState.newChat()
                onDismiss()
            }) {
                Text("+ New Chat")
                    .font(NagohTheme.sans(13, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(NagohTheme.teal)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                appState.clearAllSessions()
                onDismiss()
            }) {
                Text("Clear History")
                    .font(NagohTheme.sans(13, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .foregroundColor(NagohTheme.dim)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(NagohTheme.border2, lineWidth: 1))
                    .cornerRadius(8)
            }

            Button(action: {
                appState.signOut()
                onDismiss()
            }) {
                Text("Sign Out")
                    .font(NagohTheme.sans(13, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .foregroundColor(NagohTheme.rose)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(NagohTheme.roseMd, lineWidth: 1))
                    .cornerRadius(8)
            }
        }
        .padding(16)
    }

    // MARK: - History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            label("Past Chats")

            if appState.sessions.isEmpty {
                Text("No past chats yet")
                    .font(NagohTheme.sans(12))
                    .foregroundColor(NagohTheme.muted)
                    .padding(.vertical, 4)
            } else {
                ForEach(appState.sessions) { session in
                    Button(action: {
                        appState.loadSession(session)
                        onDismiss()
                    }) {
                        HStack {
                            Text(session.title)
                                .font(NagohTheme.sans(12))
                                .foregroundColor(
                                    appState.currentSession?.id == session.id
                                    ? NagohTheme.teal : NagohTheme.dim
                                )
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            appState.currentSession?.id == session.id
                            ? NagohTheme.tealLt : Color.clear
                        )
                        .overlay(
                            Rectangle()
                                .frame(width: 2)
                                .foregroundColor(
                                    appState.currentSession?.id == session.id
                                    ? NagohTheme.teal : Color.clear
                                ),
                            alignment: .leading
                        )
                        .cornerRadius(6)
                    }
                }
            }
        }
        .padding(16)
    }

    private func label(_ text: String) -> some View {
        Text(text)
            .font(NagohTheme.sans(9, weight: .semibold))
            .foregroundColor(NagohTheme.muted)
            .kerning(1.8)
            .textCase(.uppercase)
    }
}
