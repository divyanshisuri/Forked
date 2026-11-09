import Foundation
nonisolated enum CookTime {
    static func minutes(from text: String) -> Int? {
        let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty, value.allSatisfy({ $0.isASCII && $0.isNumber }),
              let minutes = Int(value), (1...1440).contains(minutes) else { return nil }
        return minutes
    }
    static func isValid(_ text: String) -> Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || minutes(from: text) != nil
    }
    static func label(_ minutes: Int) -> String { "\(minutes) min" }
}
