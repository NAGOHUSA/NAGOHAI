import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool
    @State private var showContentTypePicker = false

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                topBar

                Divider().background(Color.nagohBorder)

                // Message list
                messageList

                // Error
                if let error = viewModel.errorMessage {
                    ErrorBanner(message: error) {
                        viewModel.errorMessage = nil
                    }
                    .padding(.vertical, 8)
                }

                Divider().background(Color.nagohBorder)

                // Input area
                inputArea
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: – Top Bar

    private var topBar: some View {
        HStack(spacing: 12) {
            Text("✨ NAGOH AI")
                .font(.headline.weight(.bold))
                .foregroundColor(.nagohDeep)

            Spacer()

            // Token balance
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.nagohGold)
                Text("\(viewModel.tokenBalance.formatted())")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.nagohInk)
                Text("tokens")
                    .font(.caption)
                    .foregroundColor(.nagohDim)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.nagohGoldLt)
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.nagohCream)
    }

    // MARK: – Message list

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    if viewModel.messages.isEmpty {
                        emptyState
                    } else {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let last = viewModel.messages.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
        }
        .background(Color.background)
    }

    // MARK: – Empty state

    private var emptyState: some View {
        VStack(spacing: 20) {
            Text("✨")
                .font(.system(size: 50))
                .padding(.top, 40)

            Text(viewModel.selectedIndustry.placeholder)
                .font(.subheadline)
                .foregroundColor(.nagohDim)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Quick starters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.selectedIndustry.quickStarters) { starter in
                        QuickStarterCard(starter: starter) {
                            viewModel.useQuickStarter(starter)
                            isInputFocused = true
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: – Input area

    private var inputArea: some View {
        VStack(spacing: 8) {
            // Content type + industry selectors
            HStack(spacing: 8) {
                // Content type picker
                Menu {
                    ForEach(ContentType.allCases) { ct in
                        Button(action: { viewModel.selectedContentType = ct }) {
                            Label(ct.displayName, systemImage: viewModel.selectedContentType == ct ? "checkmark" : "")
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.selectedContentType.emoji)
                        Text(viewModel.selectedContentType.rawValue.capitalized)
                            .font(.caption.weight(.medium))
                            .foregroundColor(.nagohInk)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9))
                            .foregroundColor(.nagohDim)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color.nagohWarm)
                    .cornerRadius(7)
                }

                IndustryPickerRow(selectedIndustry: $viewModel.selectedIndustry)

                Spacer()

                // Clear
                if !viewModel.messages.isEmpty {
                    Button(action: { viewModel.clearMessages() }) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundColor(.nagohDim)
                    }
                }
            }
            .padding(.horizontal, 16)

            // Text input + send
            HStack(alignment: .bottom, spacing: 10) {
                TextField(viewModel.selectedIndustry.placeholder, text: $viewModel.inputText, axis: .vertical)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
                    .lineLimit(1...6)
                    .focused($isInputFocused)
                    .onSubmit {
                        if !viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Task { await viewModel.send() }
                        }
                    }

                Button(action: { Task { await viewModel.send() } }) {
                    Image(systemName: viewModel.isLoading ? "stop.circle.fill" : "arrow.up.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(
                            viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? .nagohBorder : .nagohTeal
                        )
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
        .background(Color.nagohCream)
    }
}
