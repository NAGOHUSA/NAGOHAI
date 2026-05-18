import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showGoogleSignIn = false

    var body: some View {
        ZStack {
            Color.nagohCream.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Hero
                    VStack(spacing: 16) {
                        Text("✨")
                            .font(.system(size: 64))
                            .padding(.top, 60)

                        Text("NAGOH AI")
                            .font(.system(size: 38, weight: .bold, design: .serif))
                            .foregroundColor(.nagohDeep)

                        Text("Your Small Business Assistant")
                            .font(.subheadline)
                            .foregroundColor(.nagohDim)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 48)

                    // Feature pills
                    VStack(spacing: 10) {
                        featurePill(emoji: "✍️", text: "AI content generation tailored to your industry")
                        featurePill(emoji: "📊", text: "Analytics dashboard to track what works")
                        featurePill(emoji: "🔥", text: "Daily trending topics for your niche")
                        featurePill(emoji: "📋", text: "Ready-to-use templates & power tools")
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)

                    // Auth buttons
                    VStack(spacing: 12) {
                        // Google Sign-In
                        Button(action: { showGoogleSignIn = true }) {
                            HStack(spacing: 10) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.nagohTeal)
                                Text("Continue with Google")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.nagohInk)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.nagohBorder, lineWidth: 1))
                            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                        }

                        // Guest
                        NagohButton(
                            title: "Continue as Guest",
                            icon: nil,
                            isLoading: viewModel.isLoading,
                            style: .teal
                        ) {
                            Task { await viewModel.loginAsGuest() }
                        }

                        Text("Guest sessions last 24 hours • No account required")
                            .font(.caption)
                            .foregroundColor(.nagohMuted)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)

                    // Error
                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error) {
                            viewModel.errorMessage = nil
                        }
                        .padding(.top, 16)
                    }

                    Spacer(minLength: 40)
                }
            }
        }
        .sheet(isPresented: $showGoogleSignIn) {
            GoogleSignInSheet(viewModel: viewModel, isPresented: $showGoogleSignIn)
        }
    }

    private func featurePill(emoji: String, text: String) -> some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.title3)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.nagohInk)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(12)
        .background(Color.nagohParchmt)
        .cornerRadius(8)
    }
}

// MARK: – Google Sign-In Sheet
// This sheet shows a WKWebView-based or native GoogleSignIn prompt.
// In a real project you would integrate GoogleSignIn SDK here.

import WebKit

struct GoogleSignInSheet: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 60))
                    .foregroundColor(.nagohTeal)
                    .padding(.top, 40)

                Text("Sign in with Google")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.nagohDeep)

                Text("Integrate the GoogleSignIn SDK to add\nGoogle OAuth in your Xcode project.\n\nSee README for setup instructions.")
                    .font(.subheadline)
                    .foregroundColor(.nagohDim)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                // ── In production, replace this with GoogleSignIn SDK button ──
                // Example:
                //   GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
                //       guard let idToken = result?.user.idToken?.tokenString else { return }
                //       Task { await viewModel.loginWithGoogle(idToken: idToken) }
                //   }

                NagohButton(title: "Use Guest Mode Instead", icon: "person.fill", style: .teal) {
                    isPresented = false
                    Task { await viewModel.loginAsGuest() }
                }
                .padding(.horizontal, 32)

                Spacer()
            }
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                        .foregroundColor(.nagohTeal)
                }
            }
        }
    }
}
