# NAGOH AI — iOS App

A native SwiftUI iOS application for the **NAGOH AI** business assistant platform.

## Architecture

| Layer | Pattern |
|-------|---------|
| UI | SwiftUI |
| Architecture | MVVM |
| Networking | `URLSession` + `async/await` |
| Reactive | `Combine` + `@Published` |
| Secure Storage | Keychain (`Security` framework) |
| Charts | SwiftUI Charts (iOS 16+) / fallback bar chart (iOS 14–15) |

## Project Structure

```
ios/
└── NAGOH_AI/
    ├── App/
    │   ├── NAGOH_AIApp.swift        # @main entry point
    │   └── ContentView.swift        # Root TabView / Auth gating
    │
    ├── Models/
    │   ├── Session.swift            # Auth session + API response types
    │   ├── ChatMessage.swift        # Chat messages + content types
    │   ├── AnalyticsData.swift      # Analytics + demo data
    │   ├── Template.swift           # Template & StrategyPrompt models
    │   └── TrendingTopic.swift      # Trending topics + Momentum enum
    │
    ├── Services/
    │   ├── APIClient.swift          # URLSession wrapper, all API calls
    │   └── KeychainService.swift    # Secure token storage
    │
    ├── ViewModels/
    │   ├── AuthViewModel.swift      # Auth state, Google/Guest login
    │   ├── ChatViewModel.swift      # Chat messages, sending, balance
    │   ├── AnalyticsViewModel.swift # Analytics data + demo toggle
    │   ├── TemplatesViewModel.swift # Templates, quote generator, suggestions
    │   ├── TrendingViewModel.swift  # Trending topics per industry
    │   └── SettingsViewModel.swift  # Subscription + token usage
    │
    ├── Views/
    │   ├── Auth/
    │   │   └── AuthView.swift       # Login screen (Google + Guest)
    │   ├── Chat/
    │   │   ├── ChatView.swift       # Main chat interface
    │   │   └── MessageBubble.swift  # Message bubble + quick starters
    │   ├── Analytics/
    │   │   └── AnalyticsView.swift  # Dashboard: cards, charts, table, insights
    │   ├── Templates/
    │   │   └── TemplatesView.swift  # Templates grid + power tools
    │   ├── Trending/
    │   │   └── TrendingView.swift   # Trending cards + momentum legend
    │   ├── Settings/
    │   │   └── SettingsView.swift   # Profile, subscription, logout
    │   └── Components/
    │       └── SharedComponents.swift # Reusable UI components
    │
    ├── Utilities/
    │   ├── AppColors.swift          # Brand colour palette
    │   └── IndustriesData.swift     # Industry enum + quick starters + templates
    │
    └── Resources/
        └── Info.plist
```

## Screens

| Screen | Tab | Key Features |
|--------|-----|--------------|
| Auth | — | Google OAuth, Guest login, brand hero |
| Chat | 💬 | Message thread, content type picker, industry selector, token balance |
| Analytics | 📊 | 4 metric cards, 4 charts (iOS 16 native), breakdown table, insights, demo toggle |
| Templates | 📋 | Industry templates grid, quote generator, smart suggestions, strategy prompts |
| Trending | 🔥 | Daily topics, momentum badges, add-to-chat, refresh |
| Settings | ⚙️ | Profile, plan, usage progress bar, logout |

## Setup

### Prerequisites

- Xcode 15+
- iOS 14.0+ deployment target
- Swift 5.9+

### 1. Create Xcode Project

1. Open Xcode → **New Project** → **iOS App**
2. Product Name: `NAGOH AI`
3. Bundle ID: `com.nagoh.NAGOH-AI`
4. Interface: **SwiftUI**, Language: **Swift**
5. Copy all files from `ios/NAGOH_AI/` into the Xcode project

### 2. Add Swift Package Dependencies

In Xcode: **File → Add Package Dependencies**

| Package | URL | Version |
|---------|-----|---------|
| GoogleSignIn | `https://github.com/google/GoogleSignIn-iOS` | `>= 7.0.0` |

> **Charts** — built-in from iOS 16+. The app includes a custom bar-chart fallback for iOS 14/15 so no extra package is needed.

### 3. Configure Google Sign-In

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create an OAuth 2.0 client for **iOS** with your Bundle ID
3. Download `GoogleService-Info.plist` and add it to the Xcode project
4. Add the URL scheme (`REVERSED_CLIENT_ID`) in **Info → URL Types**
5. In `AuthView.swift`, replace the stub `GoogleSignInSheet` with the real GoogleSignIn SDK call:

```swift
import GoogleSignIn

// Inside your view or coordinator:
GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
    guard let idToken = result?.user.idToken?.tokenString else { return }
    Task { await viewModel.loginWithGoogle(idToken: idToken) }
}
```

### 4. Build & Run

Select a simulator (iPhone 15, iOS 17) and press **⌘R**.

---

## API

All calls go to `https://nagohai.gregoryhogan.workers.dev`.

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/v1/auth/google` | POST | No | Google OAuth login |
| `/v1/auth/guest` | POST | No | Guest session (24hr) |
| `/v1/balance` | GET | Yes | Token balance + plan info |
| `/v1/chat` | POST | Yes | AI content generation |
| `/v1/trending` | GET | Yes | Industry trending topics |
| `/v1/analytics/dashboard` | GET | Yes | Real analytics data |
| `/v1/quotes` | GET | Yes | Quote generation |
| `/v1/suggestions` | POST | Yes | Smart content suggestions |

Session tokens are stored securely in the iOS **Keychain** using `KeychainService`.

---

## Design System

| Token | Value | Usage |
|-------|-------|-------|
| `nagohCream` | `#fdf8f0` | Background |
| `nagohTeal` | `#2a9d8f` | Primary accent, CTAs |
| `nagohGold` | `#e9a028` | Secondary accent, highlights |
| `nagohRose` | `#e8524a` | Destructive / error |
| `nagohPlum` | `#8b5cf6` | Evergreen momentum badge |
| `nagohInk` | `#3d2f24` | Body text |
| `nagohDeep` | `#2a1f16` | Headlines |
| `nagohDim` | `#8a7868` | Secondary text |

All colours are defined in `Utilities/AppColors.swift` as `Color` extensions.

---

## Content Industries

The app ships data for 8 industries, each with:
- Localised display name + emoji
- Input placeholder
- System prompt (sent to the AI)
- 5 quick starters
- Industry-specific templates
- 3 content strategy prompts

Industries: **Etsy**, **Real Estate**, **Landlord**, **Coffee Shop**, **Salon**, **Photography**, **Consulting**, **General Business**

---

## Future Enhancements

- [ ] Full GoogleSignIn SDK integration
- [ ] CoreData message persistence
- [ ] Push notifications for trending topics
- [ ] Voice input (Speech framework)
- [ ] Dark mode support
- [ ] iPad split-view layout
- [ ] Share sheet for generated content
- [ ] Subscription upgrade flow (Stripe)
- [ ] Offline mode + background sync
- [ ] Siri Shortcuts
