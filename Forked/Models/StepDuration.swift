// StepDuration.swift
// Finds a cooking time like "8-10 minutes" in a step so cook mode can offer a timer.

import Foundation

nonisolated enum StepDuration {
    static func minutes(in step: String) -> Int? {
        let pattern = #/(\d+)(?:\s*(?:-|–|to)\s*\d+)?\s*(minutes?|mins?|hours?|hrs?)\b/#.ignoresCase()
        guard let match = step.firstMatch(of: pattern), let value = Int(match.1), value > 0 else { return nil }
        let isHours = match.2.lowercased().hasPrefix("h")
        let minutes = isHours ? value * 60 : value
        return minutes <= 1440 ? minutes : nil
    }
}
