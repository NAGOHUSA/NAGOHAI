import SwiftUI

// MARK: - UpgradeView

struct UpgradeView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) var openURL
    @State private var selectedTier: PricingTier?
    @State private var isLoading = false
    @State private var errorText = ""
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 6) {
                        Text("Upgrade Your Plan")
                            .font(.custom("Georgia", size: 22))
                            .foregroundColor(NagohTheme.ink)
                        Text("More tokens, more possibilities for your business.")
                            .font(NagohTheme.sans(13))
                            .foregroundColor(NagohTheme.dim)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    // Current balance
                    HStack(spacing: 8) {
                        Text("🪙")
                        Text("Current balance: \(appState.balance.formatted()) tokens")
                            .font(NagohTheme.sans(13, weight: .medium))
                            .foregroundColor(NagohTheme.dim)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(NagohTheme.goldLt)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(NagohTheme.goldMd, lineWidth: 1))
                    .cornerRadius(20)
                    .padding(.bottom, 20)

                    // Monthly plans
                    sectionHeader("Monthly Plans")

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(PRICING_TIERS.filter { $0.billing == "monthly" }) { tier in
                            tierCard(tier)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)

                    // Annual plans
                    sectionHeader("Annual Plans  —  Save up to 21%")

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(PRICING_TIERS.filter { $0.billing == "annual" }) { tier in
                            tierCard(tier)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)

                    // CTA
                    if let tier = selectedTier {
                        VStack(spacing: 12) {
                            Divider()

                            Text("Selected: \(tier.name)")
                                .font(NagohTheme.sans(14, weight: .medium))
                                .foregroundColor(NagohTheme.ink)

                            if !errorText.isEmpty {
                                Text(errorText)
                                    .font(NagohTheme.sans(12))
                                    .foregroundColor(NagohTheme.rose)
                                    .multilineTextAlignment(.center)
                            }

                            Button(action: startCheckout) {
                                HStack {
                                    if isLoading {
                                        ProgressView().progressViewStyle(.circular).scaleEffect(0.9)
                                    }
                                    Text(isLoading ? "Loading…" : "Proceed to Checkout")
                                        .font(NagohTheme.sans(15, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(NagohTheme.teal)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .disabled(isLoading)

                            Text("Secure checkout via Stripe. Cancel anytime.")
                                .font(NagohTheme.sans(11))
                                .foregroundColor(NagohTheme.muted)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
            .background(NagohTheme.cream)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close", action: onDismiss)
                        .font(NagohTheme.sans(14))
                        .foregroundColor(NagohTheme.teal)
                }
            }
        }
    }

    // MARK: - Sub-views

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(NagohTheme.sans(11, weight: .semibold))
            .foregroundColor(NagohTheme.muted)
            .kerning(1.2)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
    }

    private func tierCard(_ tier: PricingTier) -> some View {
        let isSelected = selectedTier?.id == tier.id

        return Button(action: { selectedTier = tier }) {
            ZStack(alignment: .top) {
                VStack(spacing: 6) {
                    Text(tier.name)
                        .font(NagohTheme.sans(13, weight: .semibold))
                        .foregroundColor(NagohTheme.ink)

                    HStack(alignment: .lastTextBaseline, spacing: 1) {
                        Text(tier.priceDisplay)
                            .font(.custom("Georgia-Bold", size: 22))
                            .foregroundColor(NagohTheme.teal)
                        Text(tier.period)
                            .font(NagohTheme.sans(11))
                            .foregroundColor(NagohTheme.dim)
                    }

                    Text("\(tier.tokens) tokens")
                        .font(NagohTheme.sans(11))
                        .foregroundColor(NagohTheme.muted)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? NagohTheme.tealLt : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? NagohTheme.teal : (tier.saveBadge != nil ? NagohTheme.gold : NagohTheme.border), lineWidth: isSelected ? 2 : 1)
                )
                .cornerRadius(12)

                if let badge = tier.saveBadge {
                    Text(badge)
                        .font(NagohTheme.sans(9, weight: .semibold))
                        .foregroundColor(NagohTheme.deep)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(NagohTheme.gold)
                        .cornerRadius(8)
                        .offset(y: -10)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Checkout

    private func startCheckout() {
        guard let tier = selectedTier, let user = appState.currentUser else { return }
        isLoading = true
        errorText = ""

        Task {
            do {
                let resp = try await APIService.shared.createCheckout(
                    tier: tier.tier,
                    billing: tier.billing,
                    priceCents: tier.priceCents,
                    userId: user.userId,
                    userEmail: user.email,
                    token: appState.sessionToken
                )
                if let urlStr = resp.checkoutUrl, let url = URL(string: urlStr) {
                    await MainActor.run {
                        openURL(url)
                        onDismiss()
                    }
                } else {
                    // Fallback to direct Stripe payment link
                    await MainActor.run {
                        if let url = URL(string: "https://buy.stripe.com/4gM6oHdxyata0CVdIE1Fe06") {
                            openURL(url)
                            onDismiss()
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    errorText = error.localizedDescription
                }
            }
            await MainActor.run { isLoading = false }
        }
    }
}

#Preview {
    UpgradeView(onDismiss: {}).environmentObject(AppState())
}
