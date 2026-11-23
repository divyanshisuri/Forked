// IsChefKey.swift
// Tells any view whether the logged-in account is a Chef, so Chef-only controls can appear.

import SwiftUI

private struct IsChefKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isChef: Bool {
        get { self[IsChefKey.self] }
        set { self[IsChefKey.self] = newValue }
    }
}
