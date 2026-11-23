// Hashes and checks passwords with PBKDF2-HMAC-SHA256 (CommonCrypto) and random salts (CryptoKit).
import CommonCrypto
import CryptoKit
import Foundation

// nonisolated so the slow hashing can run on a background task instead of the main thread.
nonisolated enum PasswordHasher {
    /// OWASP's recommended minimum for PBKDF2-HMAC-SHA256.
    static let iterations = 600_000
    static let keyLength = 32

    /// Returns 16 random bytes to use as a new user's salt.
    static func makeSalt() -> Data {
        SymmetricKey(size: .bits128).withUnsafeBytes { Data($0) }
    }

    /// Derives the password hash, or returns nil if CommonCrypto reports an error.
    static func hash(password: String, salt: Data, iterations: Int) -> Data? {
        guard iterations > 0, !salt.isEmpty else { return nil }
        var derived = Data(count: keyLength)
        let status = derived.withUnsafeMutableBytes { derivedBytes in
            salt.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    password.utf8.count,
                    saltBytes.bindMemory(to: UInt8.self).baseAddress,
                    salt.count,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                    UInt32(iterations),
                    derivedBytes.bindMemory(to: UInt8.self).baseAddress,
                    keyLength
                )
            }
        }
        // The C constants import as Int, while the function returns Int32.
        return status == Int32(kCCSuccess) ? derived : nil
    }

    /// True if `password` produces `expectedHash` with this salt and iteration count.
    static func verify(password: String, salt: Data, iterations: Int, expectedHash: Data) -> Bool {
        guard let candidate = hash(password: password, salt: salt, iterations: iterations) else { return false }
        return constantTimeEquals(candidate, expectedHash)
    }

    // Looks at every byte even after a mismatch, so the time taken doesn't reveal how much matched.
    private static func constantTimeEquals(_ lhs: Data, _ rhs: Data) -> Bool {
        guard lhs.count == rhs.count else { return false }
        var difference: UInt8 = 0
        for (left, right) in zip(lhs, rhs) {
            difference |= left ^ right
        }
        return difference == 0
    }
}
