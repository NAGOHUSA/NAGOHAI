import SwiftUI

struct SettingsView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showLogoutConfirm = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Profile card
                        if let session = authViewModel.session {
                            profileCard(session: session)
                        }

                        // Subscription card
                        subscriptionCard

                        // Token usage card
                        usageCard

                        // Actions
                        actionsCard

                        // App version
                        Text("NAGOH AI · v1.0")
                            .font(.caption)
                            .foregroundColor(.nagohMuted)
                            .padding(.bottom, 20)
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.loadBalance() }
            .confirmationDialog("Sign Out", isPresented: $showLogoutConfirm, titleVisibility: .visible) {
                Button("Sign Out", role: .destructive) { authViewModel.logout() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You will need to sign in again to continue.")
            }
        }
    }

    // MARK: – Profile Card

    private func profileCard(session: Session) -> some View {
        VStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.nagohTeal.opacity(0.15))
                    .frame(width: 72, height: 72)

                if let url = session.picture {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        avatarPlaceholder(name: session.name)
                    }
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                } else {
                    avatarPlaceholder(name: session.name)
                }
            }

            VStack(spacing: 4) {
                Text(session.name)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.nagohDeep)
                Text(session.email)
                    .font(.subheadline)
                    .foregroundColor(.nagohDim)

                if session.isGuest {
                    Label("Guest Session · 24hr", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.nagohGold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.nagohGoldLt)
                        .cornerRadius(6)
                        .padding(.top, 4)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    private func avatarPlaceholder(name: String) -> some View {
        Text(String(name.prefix(1)).uppercased())
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.nagohTeal)
    }

    // MARK: – Subscription Card

    private var subscriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Subscription")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.nagohInk)
                Spacer()
            }

            HStack(spacing: 12) {
                Text(viewModel.planEmoji)
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(Color.nagohTealLt)
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.planDisplayName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.nagohInk)
                    Text("Current plan")
                        .font(.caption)
                        .foregroundColor(.nagohDim)
                }

                Spacer()

                if viewModel.plan.lowercased() == "free" || viewModel.plan.lowercased() == "starter" {
                    Text("Upgrade")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.nagohGold)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    // MARK: – Token Usage Card

    private var usageCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Token Usage")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.nagohInk)

            HStack {
                Text("\(viewModel.monthlyUsed.formatted()) used")
                    .font(.subheadline)
                    .foregroundColor(.nagohInk)
                Spacer()
                Text("of \(viewModel.monthlyLimit.formatted())")
                    .font(.caption)
                    .foregroundColor(.nagohDim)
            }

            ProgressView(value: viewModel.usageProgress)
                .tint(viewModel.usageProgress > 0.8 ? .nagohRose : .nagohTeal)
                .scaleEffect(x: 1, y: 1.5, anchor: .center)

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.caption)
                        .foregroundColor(.nagohGold)
                    Text("\(viewModel.tokenBalance.formatted()) remaining balance")
                        .font(.caption)
                        .foregroundColor(.nagohDim)
                }
                Spacer()
                Text("\(Int(viewModel.usageProgress * 100))%")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(viewModel.usageProgress > 0.8 ? .nagohRose : .nagohDim)
            }
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    // MARK: – Actions

    private var actionsCard: some View {
        VStack(spacing: 0) {
            actionRow(icon: "questionmark.circle", title: "Help & Support", color: .nagohTeal) {}
            Divider().padding(.leading, 52)
            actionRow(icon: "doc.text", title: "Privacy Policy", color: .nagohTeal) {}
            Divider().padding(.leading, 52)
            actionRow(icon: "person.badge.shield.checkmark", title: "Terms of Service", color: .nagohTeal) {}
            Divider().padding(.leading, 52)
            actionRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", color: .nagohRose) {
                showLogoutConfirm = true
            }
        }
        .background(Color.cardBg)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    private func actionRow(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(color)
                    .frame(width: 28)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(title == "Sign Out" ? .nagohRose : .nagohInk)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.nagohMuted)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}
