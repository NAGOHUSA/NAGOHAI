import SwiftUI

struct TemplatesView: View {
    @StateObject private var viewModel = TemplatesViewModel()
    @EnvironmentObject private var chatViewModel: ChatViewModel

    // Quote tool state
    @State private var quoteName    = ""
    @State private var quoteService = ""
    @State private var quoteScope   = ""
    @State private var quoteBudget  = ""
    @State private var suggestText  = ""
    @State private var selectedTemplate: AppTemplate?

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Error
                        if let error = viewModel.errorMessage {
                            ErrorBanner(message: error) { viewModel.errorMessage = nil }
                        }

                        // Industry selector
                        industrySelector

                        // Power Tools
                        powerToolsSection

                        // Templates grid
                        templatesSection

                        // Strategy prompts
                        strategySection
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Templates & Tools")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedTemplate) { template in
                TemplateDetailSheet(
                    template: template,
                    onSendToChat: { prompt in
                        chatViewModel.inputText = prompt
                        selectedTemplate = nil
                    }
                )
            }
        }
    }

    // MARK: – Industry Selector

    private var industrySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Industry.allCases) { industry in
                    Button(action: { viewModel.selectIndustry(industry) }) {
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

    // MARK: – Power Tools

    private var powerToolsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Power Tools")
                .font(.subheadline.weight(.bold))
                .foregroundColor(.nagohInk)
                .padding(.horizontal, 16)

            VStack(spacing: 16) {
                // Quote Generator
                quoteGeneratorCard

                // Smart Suggestions
                suggestionsCard
            }
            .padding(.horizontal, 16)
        }
    }

    private var quoteGeneratorCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💰 Quote Generator")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.nagohInk)

            VStack(spacing: 8) {
                TextField("Client name", text: $quoteName)
                    .textFieldStyle(.nagoh)
                TextField("Service type", text: $quoteService)
                    .textFieldStyle(.nagoh)
                TextField("Scope", text: $quoteScope)
                    .textFieldStyle(.nagoh)
                TextField("Budget / pricing range", text: $quoteBudget)
                    .textFieldStyle(.nagoh)
            }

            NagohButton(title: "Generate Quote", icon: "sparkles", isLoading: viewModel.isLoadingQuote, style: .teal) {
                Task { await viewModel.generateQuote(name: quoteName, service: quoteService, scope: quoteScope, budget: quoteBudget) }
            }

            if let result = viewModel.quoteResult {
                resultBox(text: result)
            }
        }
        .padding(16)
        .background(Color.nagohGoldLt)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohGold.opacity(0.4), lineWidth: 1))
    }

    private var suggestionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("✨ Smart Suggestions")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.nagohInk)

            TextEditor(text: $suggestText)
                .frame(minHeight: 80)
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.nagohBorder, lineWidth: 1))
                .font(.subheadline)
                .overlay(
                    Group {
                        if suggestText.isEmpty {
                            Text("Paste your content here…")
                                .foregroundColor(.nagohMuted)
                                .font(.subheadline)
                                .padding(12)
                                .allowsHitTesting(false)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                    }
                )

            NagohButton(title: "Get Suggestions", icon: "lightbulb.fill", isLoading: viewModel.isLoadingSuggestions, style: .teal) {
                Task { await viewModel.getSuggestions(content: suggestText) }
            }

            if let result = viewModel.suggestionsResult {
                resultBox(text: result)
            }
        }
        .padding(16)
        .background(Color.nagohGoldLt)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohGold.opacity(0.4), lineWidth: 1))
    }

    private func resultBox(text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.nagohInk)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)

            HStack(spacing: 8) {
                Button(action: { UIPasteboard.general.string = text }) {
                    Label("Copy", systemImage: "doc.on.doc")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.nagohTeal)
                }
                Button(action: { chatViewModel.inputText = text }) {
                    Label("Send to Chat", systemImage: "arrow.up.circle")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.nagohTeal)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.nagohBorder, lineWidth: 1))
    }

    // MARK: – Templates

    private var templatesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📚 Templates for \(viewModel.selectedIndustry.displayName)")
                .font(.subheadline.weight(.bold))
                .foregroundColor(.nagohInk)
                .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.templates) { template in
                    templateCard(template)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func templateCard(_ template: AppTemplate) -> some View {
        Button(action: { selectedTemplate = template }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(template.emoji)
                    .font(.title2)
                Text(template.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.nagohInk)
                    .lineLimit(1)
                Text(template.description)
                    .font(.caption)
                    .foregroundColor(.nagohDim)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    Spacer()
                    Image(systemName: "arrow.right.circle")
                        .font(.caption)
                        .foregroundColor(.nagohTeal)
                }
            }
            .padding(12)
            .background(Color.cardBg)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
        }
    }

    // MARK: – Strategy prompts

    private var strategySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎯 Content Strategy Prompts")
                .font(.subheadline.weight(.bold))
                .foregroundColor(.nagohInk)
                .padding(.horizontal, 16)

            VStack(spacing: 10) {
                ForEach(viewModel.strategyPrompts) { strategy in
                    strategyRow(strategy)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func strategyRow(_ strategy: StrategyPrompt) -> some View {
        HStack(spacing: 12) {
            Text(strategy.emoji)
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(Color.nagohWarm)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(strategy.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.nagohInk)
                Text(strategy.description)
                    .font(.caption)
                    .foregroundColor(.nagohDim)
            }

            Spacer()

            Button(action: { chatViewModel.inputText = strategy.prompt }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title3)
                    .foregroundColor(.nagohTeal)
            }
        }
        .padding(12)
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
    }
}

// MARK: – Template Detail Sheet

struct TemplateDetailSheet: View {
    let template: AppTemplate
    let onSendToChat: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var copied = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Text(template.emoji)
                            .font(.system(size: 48))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(template.title)
                                .font(.title3.weight(.bold))
                                .foregroundColor(.nagohDeep)
                            Text(template.description)
                                .font(.subheadline)
                                .foregroundColor(.nagohDim)
                        }
                    }
                    .padding(.horizontal, 16)

                    Text(template.content)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.nagohInk)
                        .padding(16)
                        .background(Color.nagohParchmt)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .textSelection(.enabled)

                    HStack(spacing: 12) {
                        NagohButton(
                            title: copied ? "Copied!" : "Copy Template",
                            icon: copied ? "checkmark" : "doc.on.doc",
                            style: .outline
                        ) {
                            UIPasteboard.general.string = template.content
                            copied = true
                            Task {
                                try? await Task.sleep(nanoseconds: 2_000_000_000)
                                copied = false
                            }
                        }

                        NagohButton(title: "Send to Chat", icon: "arrow.up.circle", style: .teal) {
                            let prompt = "Use this template:\n\n\(template.content)"
                            onSendToChat(prompt)
                            dismiss()
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.nagohTeal)
                }
            }
        }
    }
}

// MARK: – TextField style helper

struct NagohTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.nagohBorder, lineWidth: 1))
            .font(.subheadline)
    }
}

extension TextFieldStyle where Self == NagohTextFieldStyle {
    static var nagoh: NagohTextFieldStyle { NagohTextFieldStyle() }
}
