// The two kinds of account: chefs, who post recipes, and consumers, who find and save them.
import Foundation

nonisolated enum UserRole: String, CaseIterable, Codable, Identifiable {
    case chef
    case consumer

    var id: Self { self }

    var title: String {
        switch self {
        case .chef: "Chef"
        case .consumer: "Consumer"
        }
    }

    var symbolName: String {
        switch self {
        case .chef: "frying.pan"
        case .consumer: "fork.knife.circle"
        }
    }

    /// One line shown under the role picker on the sign-up screen.
    var summary: String {
        switch self {
        case .chef: "Post recipes and keep them up to date."
        case .consumer: "Find, rate and save recipes from chefs."
        }
    }
}
