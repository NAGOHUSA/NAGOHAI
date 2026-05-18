import SwiftUI

@main
struct NAGOH_AIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // warm palette looks best in light mode; remove to support dark
        }
    }
}
