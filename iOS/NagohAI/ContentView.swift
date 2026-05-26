import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isAuthenticated {
                ChatView()
            } else {
                AuthView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.isAuthenticated)
    }
}

#Preview {
    ContentView().environmentObject(AppState())
}
