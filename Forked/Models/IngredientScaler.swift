// IngredientScaler.swift
// Scales the quantity at the start of an ingredient line, such as 1 1/2 cups to 3 cups.

import Foundation

nonisolated enum IngredientScaler {
    private static let vulgarFractions: [Character: Double] = [
        "½": 0.5, "⅓": 1.0 / 3, "⅔": 2.0 / 3, "¼": 0.25, "¾": 0.75, "⅛": 0.125, "⅜": 0.375, "⅝": 0.625, "⅞": 0.875
    ]
    private static let displayFractions: [(Double, String)] = [
        (0, ""), (0.125, "⅛"), (0.25, "¼"), (1.0 / 3, "⅓"), (0.375, "⅜"), (0.5, "½"),
        (0.625, "⅝"), (2.0 / 3, "⅔"), (0.75, "¾"), (0.875, "⅞"), (1, "")
    ]

    static func scale(_ text: String, by factor: Double) -> String {
        guard factor != 1, factor > 0 else { return text }
        var words = text.split(separator: " ", omittingEmptySubsequences: false)
        guard let first = words.first else { return text }

        if let range = parseRange(first) {
            words[0] = Substring(format(range.0 * factor) + "–" + format(range.1 * factor))
            return words.joined(separator: " ")
        }
        guard var amount = number(first) else { return text }
        var consumed = 1
        if words.count > 1, first.allSatisfy(\.isNumber), let fraction = fraction(words[1]) {
            amount += fraction
            consumed = 2
        }
        let rest = words.dropFirst(consumed)
        return ([Substring(format(amount * factor))] + rest).joined(separator: " ")
    }

    private static func parseRange(_ word: Substring) -> (Double, Double)? {
        let parts = word.split(whereSeparator: { $0 == "-" || $0 == "–" })
        guard parts.count == 2, let low = number(parts[0]), let high = number(parts[1]) else { return nil }
        return (low, high)
    }

    private static func number(_ word: Substring) -> Double? {
        guard let head = word.first, head.isNumber || vulgarFractions[head] != nil else { return nil }
        if let value = Double(word), value.isFinite { return value }
        if let value = fraction(word) { return value }
        if let last = word.last, let tail = vulgarFractions[last] {
            let whole = word.dropLast()
            if whole.isEmpty { return tail }
            if whole.allSatisfy(\.isNumber), let value = Double(whole) { return value + tail }
        }
        return nil
    }

    private static func fraction(_ word: Substring) -> Double? {
        if word.count == 1, let char = word.first, let value = vulgarFractions[char] { return value }
        let parts = word.split(separator: "/")
        guard parts.count == 2, let top = Double(parts[0]), let bottom = Double(parts[1]), bottom > 0,
              parts.allSatisfy({ $0.allSatisfy(\.isNumber) }) else { return nil }
        return top / bottom
    }

    static func format(_ value: Double) -> String {
        if value >= 10 { return String(Int(value.rounded())) }
        var whole = Int(value)
        let remainder = value - Double(whole)
        let nearest = displayFractions.min { abs($0.0 - remainder) < abs($1.0 - remainder) } ?? (0, "")
        if nearest.0 == 1 { whole += 1 }
        if whole == 0 && nearest.1.isEmpty { return "⅛" }
        return (whole > 0 ? String(whole) : "") + nearest.1
    }
}
