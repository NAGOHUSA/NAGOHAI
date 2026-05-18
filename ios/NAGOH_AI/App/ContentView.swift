import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var chatViewModel = ChatViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                mainTabView
            } else {
                AuthView(viewModel: authViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authViewModel.isAuthenticated)
        // Keep chatViewModel in sync with auth token
        .onChange(of: authViewModel.session?.token) { token in
            APIClient.shared.sessionToken = token
        }
    }

    private var mainTabView: some View {
        TabView {
            ChatView(viewModel: chatViewModel)
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }

            TemplatesView()
                .environmentObject(chatViewModel)
                .tabItem {
                    Label("Templates", systemImage: "doc.text.fill")
                }

            TrendingView()
                .environmentObject(chatViewModel)
                .tabItem {
                    Label("Trending", systemImage: "flame.fill")
                }

            SettingsView(authViewModel: authViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.nagohTeal)
        .onAppear {
            // Sync balance after auth
            Task { await chatViewModel.refreshBalance() }
            // Carry session token to chat VM
            if let token = authViewModel.session?.token {
                APIClient.shared.sessionToken = token
            }
            // Keep chat industry in sync (initial)
            if let session = authViewModel.session {
                chatViewModel.tokenBalance = session.tokenBalance
            }
        }
    }
}
