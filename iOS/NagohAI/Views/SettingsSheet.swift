import SwiftUI

// MARK: - SettingsSheet

struct SettingsSheet: View {
    @EnvironmentObject var appState: AppState
    @Binding var inputText: String
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Stats
                    statsSection

                    Divider().background(NagohTheme.border)

                    // Model selector
                    modelSection

                    Divider().background(NagohTheme.border)

                    // Tone selector
                    toneSection

                    Divider().background(NagohTheme.border)

                    // Ideas
                    ideasSection
                }
            }
            .background(NagohTheme.parchment)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: onDismiss)
                        .font(NagohTheme.sans(14, weight: .medium))
                        .foregroundColor(NagohTheme.teal)
                }
            }
        }
    }

    // MARK: - Stats

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            label("This Chat")

            HStack(spacing: 12) {
                statCard(value: "\(appState.messages.count)", subtitle: "messages")
                statCard(value: "\(appState.sessionSpent)", subtitle: "tokens used", valueColor: NagohTheme.teal)
            }
        }
        .padding(16)
    }

    private func statCard(value: String, subtitle: String, valueColor: Color = NagohTheme.ink) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.custom("Georgia", size: 18))
                .foregroundColor(valueColor)
            Text(subtitle)
                .font(NagohTheme.sans(9))
                .foregroundColor(NagohTheme.muted)
                .kerning(0.8)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(NagohTheme.border, lineWidth: 1))
        .cornerRadius(8)
    }

    // MARK: - Model

    private var modelSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            label("AI Model")

            VStack(spacing: 6) {
                ForEach(AIModel.allCases) { model in
                    Button(action: {
                        appState.selectedModel = model
                        appState.saveSettings()
                    }) {
                        HStack {
                            Text(model.displayName)
                                .font(NagohTheme.sans(13))
                                .foregroundColor(NagohTheme.ink)
                            Spacer()
                            if appState.selectedModel == model {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(NagohTheme.teal)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(appState.selectedModel == model ? NagohTheme.tealLt : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(appState.selectedModel == model ? NagohTheme.tealMd : NagohTheme.border, lineWidth: 1)
                        )
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
    }

    // MARK: - Tone

    private var toneSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            label("Tone / Mode")

            VStack(spacing: 6) {
                ForEach(ToneMode.allCases) { tone in
                    Button(action: {
                        appState.selectedTone = tone
                        appState.saveSettings()
                    }) {
                        HStack {
                            Text(tone.displayName)
                                .font(NagohTheme.sans(13))
                                .foregroundColor(NagohTheme.ink)
                            Spacer()
                            if appState.selectedTone == tone {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(NagohTheme.teal)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(appState.selectedTone == tone ? NagohTheme.tealLt : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(appState.selectedTone == tone ? NagohTheme.tealMd : NagohTheme.border, lineWidth: 1)
                        )
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
    }

    // MARK: - Ideas

    private var ideasSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            label("💡 Ideas to Try")

            ForEach(INDUSTRIES[appState.currentIndustry]?.ideas ?? []) { idea in
                Button(action: {
                    inputText = "\(idea.title.lowercased()): "
                    onDismiss()
                }) {
                    HStack(alignment: .top, spacing: 8) {
                        Text(idea.emoji).font(.system(size: 16))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(idea.title)
                                .font(NagohTheme.sans(12, weight: .medium))
                                .foregroundColor(NagohTheme.ink)
                            Text(idea.desc)
                                .font(NagohTheme.sans(11))
                                .foregroundColor(NagohTheme.dim)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 7)
                    .background(Color.clear)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
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
