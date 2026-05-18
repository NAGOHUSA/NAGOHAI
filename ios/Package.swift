// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NAGOH_AI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "NAGOH_AI", targets: ["NAGOH_AI"])
    ],
    dependencies: [
        // Google Sign-In
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS",
            from: "7.0.0"
        ),
        // Keychain helper (optional — app ships its own KeychainService, but this is here for reference)
        .package(
            url: "https://github.com/kishikawakatsumi/KeychainAccess",
            from: "4.2.0"
        ),
    ],
    targets: [
        .target(
            name: "NAGOH_AI",
            dependencies: [
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                // Uncomment if you prefer KeychainAccess over the built-in KeychainService:
                // .product(name: "KeychainAccess", package: "KeychainAccess"),
            ],
            path: "NAGOH_AI"
        ),
    ]
)
