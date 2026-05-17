# NAGOH AI — iOS App

A native SwiftUI iOS app that mirrors and extends the [NAGOH AI](https://ai.nagoh.us) web experience.

## Opening in Xcode

1. Open `NagohAI.xcodeproj` directly in Xcode (14 or later).
2. Select your target device or simulator.
3. Set your Apple development team in **Signing & Capabilities** → **Team**.
4. Press **⌘R** to build and run.

## Features

| Feature | Details |
|---|---|
| **Authentication** | Google Sign-In (OAuth2) + Guest mode |
| **13 Industries** | Etsy, Real Estate, Landlord, Coffee Shop, Landscaping, Roofing, Plumbing, Salon, Photography, Personal Training, Insurance, Consulting, General |
| **AI Chat** | Full conversation with the NAGOH AI worker backend |
| **Quick Starters** | 5 industry-specific prompts per industry |
| **Ideas Panel** | 7 topic ideas per industry |
| **Tone Selector** | Friendly / Professional / Playful / Concise |
| **Model Selector** | NagohAI Chat (fast) / NagohAI Reasoner (deep) |
| **Token Balance** | Live balance display, refreshes on launch |
| **Chat History** | Persistent via UserDefaults, up to 50 sessions |
| **Upgrade / Buy Tokens** | Pricing modal → Stripe checkout |
| **Theme** | Warm cream/parchment/teal/gold palette matching the website |

## Backend

Connects to the existing Cloudflare Worker:

```
https://nagohai.gregoryhogan.workers.dev
```

**API Endpoints used:**

| Endpoint | Purpose |
|---|---|
| `POST /v1/auth/google` | Exchange Google id_token for session |
| `POST /v1/auth/guest`  | Create guest session |
| `GET  /v1/balance`     | Fetch token balance |
| `POST /v1/chat`        | Send a chat message |
| `POST /v1/checkout/session` | Create Stripe checkout |

## Google Sign-In Setup

For Google Sign-In to work natively, you need to configure an **iOS OAuth client ID** in [Google Cloud Console](https://console.cloud.google.com):

1. Go to **APIs & Services** → **Credentials**.
2. Create an **OAuth 2.0 Client ID** of type **iOS**.
3. Set the **Bundle ID** to `us.nagoh.ai.NagohAI`.
4. In **Authorized redirect URIs**, add `nagoh-ai://oauth2redirect`.
5. Update the `clientID` constant in `Views/AuthView.swift` with the new iOS client ID.

> **Guest mode works immediately** without any Google Cloud configuration.

## Stripe / Payment Success Deep Link

After a successful Stripe payment, the web redirect should point back to:

```
nagoh-ai://payment?status=success
```

Add this to your Stripe payment link's success URL (or configure via the Cloudflare Worker).

## Project Structure

```
iOS/
├── NagohAI.xcodeproj/
│   └── project.pbxproj
└── NagohAI/
    ├── NagohAIApp.swift          — App entry point
    ├── ContentView.swift         — Root routing view
    ├── Theme.swift               — Color palette & font helpers
    ├── Info.plist                — Bundle config & URL schemes
    ├── Assets.xcassets/          — App icon & accent color
    ├── Models/
    │   ├── AppState.swift        — Central ObservableObject state
    │   ├── ChatModels.swift      — Message, session, metadata types
    │   └── IndustryData.swift    — All 13 industry configs
    ├── Services/
    │   └── APIService.swift      — Worker API calls (async/await)
    └── Views/
        ├── AuthView.swift        — Sign-in / guest screen
        ├── ChatView.swift        — Main chat interface
        ├── MessageBubbleView.swift — Chat bubble component
        ├── SidebarSheet.swift    — Industry, quick starters, history
        ├── SettingsSheet.swift   — Model, tone, ideas panel
        └── UpgradeView.swift     — Pricing tiers / token purchase
```

## Requirements

- Xcode 14+
- iOS 16.0+ deployment target
- Swift 5.9+

## Optional: Custom Fonts

The website uses **Fraunces** (serif) and **DM Sans**. To match exactly:

1. Download `Fraunces-Regular.ttf`, `Fraunces-Italic.ttf`, and `Fraunces-Bold.ttf` from [Google Fonts](https://fonts.google.com/specimen/Fraunces).
2. Download `DMSans-Regular.ttf` and `DMSans-Medium.ttf`.
3. Add all font files to `NagohAI/` in the Xcode project.
4. Register them in `Info.plist` under `UIAppFonts`.
5. Update the font names in `Theme.swift` from `"Georgia"` to `"Fraunces-Regular"`.
