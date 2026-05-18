import Foundation

struct AppTemplate: Identifiable {
    let id: String
    let emoji: String
    let title: String
    let description: String
    let content: String
    let industry: Industry
}

struct StrategyPrompt: Identifiable {
    let id: String
    let emoji: String
    let title: String
    let description: String
    let prompt: String
    let industry: Industry
}
