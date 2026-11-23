// What the user types on the log-in and sign-up screens, and the rules a new account must meet.
import Foundation

nonisolated struct Credentials: Equatable {
    /// One line of the sign-up checklist.
    nonisolated struct Rule: Identifiable, Equatable {
        let text: String
        let isMet: Bool

        var id: String { text }
    }

    static let usernameLengths = 3...20
    static let minimumPasswordLength = 8

    var username = ""
    var password = ""
    var confirmPassword = ""
    var role: UserRole = .consumer

    /// The form used for lookups, so "Sam" and "sam" are the same account.
    static func key(for username: String) -> String {
        username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    var trimmedUsername: String { username.trimmingCharacters(in: .whitespacesAndNewlines) }
    var usernameKey: String { Self.key(for: username) }

    // Functional: each rule is a pure check on the typed text, and canSignUp combines them with allSatisfy.
    var usernameRules: [Rule] {
        [
            Rule(
                text: "\(Self.usernameLengths.lowerBound)–\(Self.usernameLengths.upperBound) characters",
                isMet: Self.usernameLengths.contains(trimmedUsername.count)
            ),
            Rule(
                text: "Only letters, numbers, dots or underscores",
                isMet: !trimmedUsername.isEmpty && trimmedUsername.allSatisfy(Self.isAllowedInUsername)
            )
        ]
    }

    var passwordRules: [Rule] {
        [
            Rule(text: "At least \(Self.minimumPasswordLength) characters", isMet: password.count >= Self.minimumPasswordLength),
            Rule(text: "At least one letter", isMet: password.contains(where: \.isLetter)),
            Rule(text: "At least one number", isMet: password.contains(where: \.isNumber)),
            Rule(text: "Passwords match", isMet: !confirmPassword.isEmpty && password == confirmPassword)
        ]
    }

    var canLogIn: Bool { !trimmedUsername.isEmpty && !password.isEmpty }
    var canSignUp: Bool { (usernameRules + passwordRules).allSatisfy(\.isMet) }

    private static func isAllowedInUsername(_ character: Character) -> Bool {
        character.isASCII && (character.isLetter || character.isNumber || character == "." || character == "_")
    }
}
