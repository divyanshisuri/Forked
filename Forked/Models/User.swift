// A local account on this device (chef or consumer), with the sign-up and log-in logic.
// Recipes, favorites and ratings are linked to users in KAN-9 part 2.
import Foundation
import SwiftData

// Object-oriented: User keeps an account's data together with the behaviour that creates and checks it.
@Model
final class User {
    var accountID: UUID = UUID()
    var username: String = ""
    /// Trimmed, lowercased username used for lookups.
    var usernameKey: String = ""
    // Stored as text because SwiftData on iOS 17 can't reliably filter on enum values.
    var roleRawValue: String = "consumer"
    var passwordHash: Data = Data()
    var passwordSalt: Data = Data()
    // Stored per user so the iteration count can be raised later without breaking existing accounts.
    var passwordIterations: Int = 0
    var createdAt: Date = Date.now

    init(
        username: String = "",
        role: UserRole = .consumer,
        passwordHash: Data = Data(),
        passwordSalt: Data = Data(),
        passwordIterations: Int = 0,
        createdAt: Date = .now
    ) {
        self.accountID = UUID()
        self.username = username
        self.usernameKey = Credentials.key(for: username)
        self.roleRawValue = role.rawValue
        self.passwordHash = passwordHash
        self.passwordSalt = passwordSalt
        self.passwordIterations = passwordIterations
        self.createdAt = createdAt
    }
}

extension User {
    nonisolated enum AuthError: LocalizedError {
        case invalidCredentials
        case usernameTaken
        case incorrectLogin
        case failed

        var errorDescription: String? {
            switch self {
            case .invalidCredentials: "Check the requirements below."
            case .usernameTaken: "That username is already taken."
            case .incorrectLogin: "Incorrect username or password."
            case .failed: "Something went wrong. Please try again."
            }
        }
    }

    var role: UserRole {
        get { UserRole(rawValue: roleRawValue) ?? .consumer }
        set { roleRawValue = newValue.rawValue }
    }

    /// Finds the account with this lookup key, if there is one.
    static func existing(usernameKey key: String, in context: ModelContext) throws -> User? {
        var descriptor = FetchDescriptor<User>(predicate: #Predicate<User> { $0.usernameKey == key })
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    /// Creates and saves a new account, hashing the password off the main thread.
    static func signUp(_ credentials: Credentials, in context: ModelContext) async throws -> User {
        guard credentials.canSignUp else { throw AuthError.invalidCredentials }
        // Uniqueness is checked here rather than with @Attribute(.unique), because SwiftData treats a
        // duplicate unique value as an update and would overwrite the other account's password.
        let key = credentials.usernameKey
        guard try existing(usernameKey: key, in: context) == nil else { throw AuthError.usernameTaken }

        let password = credentials.password
        let salt = PasswordHasher.makeSalt()
        let iterations = PasswordHasher.iterations
        let derivedHash = await Task.detached {
            PasswordHasher.hash(password: password, salt: salt, iterations: iterations)
        }.value
        guard let hash = derivedHash else { throw AuthError.failed }
        // Check again: another sign-up could have taken the name while we were hashing.
        guard try existing(usernameKey: key, in: context) == nil else { throw AuthError.usernameTaken }

        let user = User(
            username: credentials.trimmedUsername,
            role: credentials.role,
            passwordHash: hash,
            passwordSalt: salt,
            passwordIterations: iterations
        )
        context.insert(user)
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
        return user
    }

    /// Returns the matching account if the password is right. A wrong name and a wrong password give the same error.
    static func logIn(_ credentials: Credentials, in context: ModelContext) async throws -> User {
        guard credentials.canLogIn,
              let user = try existing(usernameKey: credentials.usernameKey, in: context) else {
            throw AuthError.incorrectLogin
        }
        let password = credentials.password
        let salt = user.passwordSalt
        let iterations = user.passwordIterations
        let expectedHash = user.passwordHash
        let matches = await Task.detached {
            PasswordHasher.verify(password: password, salt: salt, iterations: iterations, expectedHash: expectedHash)
        }.value
        guard matches else { throw AuthError.incorrectLogin }
        return user
    }
}
