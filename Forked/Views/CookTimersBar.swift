// CookTimersBar.swift
// Running cook-mode timers, shown on every page; tap one to jump to its step.

import SwiftUI

struct CookTimersBar: View {
    let timerEnds: [Int: Date]
    let onSelect: (Int) -> Void

    var body: some View {
        if !timerEnds.isEmpty {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(timerEnds.keys.sorted(), id: \.self) { index in
                            let remaining = max(0, timerEnds[index, default: .now].timeIntervalSince(context.date))
                            Button { onSelect(index) } label: {
                                Label("Step \(index + 1) · \(StepTimerView.format(remaining))",
                                      systemImage: remaining == 0 ? "bell.fill" : "timer")
                                    .font(.subheadline.weight(.medium).monospacedDigit())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(remaining == 0 ? Theme.red : Theme.surface, in: Capsule())
                                    .foregroundStyle(remaining == 0 ? Theme.onAccent : Theme.text)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.top, 8)
        }
    }
}
