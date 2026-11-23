// StepTimerView.swift
// A countdown for one cook-mode step. Starting it also schedules a local notification for when it ends.

import SwiftUI

struct StepTimerView: View {
    let minutes: Int
    let step: Int
    let recipeTitle: String
    let notificationID: String
    @Binding var endDate: Date?

    var body: some View {
        if let endDate {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let remaining = max(0, endDate.timeIntervalSince(context.date))
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(remaining == 0 ? "Time's up" : "Timer running")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.secondaryText)
                        Text(StepTimerView.format(remaining))
                            .font(.system(.largeTitle, design: .rounded).weight(.semibold).monospacedDigit())
                            .foregroundStyle(Theme.text)
                    }
                    Spacer()
                    Button(remaining == 0 ? "Dismiss" : "Cancel") {
                        TimerNotifier.cancel(ids: [notificationID])
                        self.endDate = nil
                    }
                        .buttonStyle(.outline)
                }
                .padding(16)
                .background(Theme.surface, in: RoundedRectangle(cornerRadius: 14))
                .sensoryFeedback(.warning, trigger: remaining == 0) { _, isDone in isDone }
                .accessibilityElement(children: .combine)
            }
        } else {
            Button {
                let seconds = Double(minutes) * 60
                endDate = .now.addingTimeInterval(seconds)
                TimerNotifier.schedule(id: notificationID, recipeTitle: recipeTitle, step: step, seconds: seconds)
            } label: {
                Label("Start \(CookTime.label(minutes)) timer", systemImage: "timer")
            }
            .buttonStyle(.outline)
        }
    }

    static func format(_ seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded(.up))
        let hours = total / 3600, mins = total % 3600 / 60, secs = total % 60
        return hours > 0 ? String(format: "%d:%02d:%02d", hours, mins, secs) : String(format: "%d:%02d", mins, secs)
    }
}
