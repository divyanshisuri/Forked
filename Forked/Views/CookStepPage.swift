// CookStepPage.swift
// One page of cook mode: the step in large type and a timer when the step mentions a time.

import SwiftUI

struct CookStepPage: View {
    let number: Int
    let total: Int
    let text: String
    let recipeTitle: String
    let notificationID: String
    @Binding var timerEnd: Date?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text("STEP \(number) OF \(total)")
                    .font(.caption.weight(.semibold))
                    .tracking(1.8)
                    .foregroundStyle(Theme.secondaryText)
                Text(text)
                    .font(.largeTitle)
                    .fontDesign(.serif)
                    .foregroundStyle(Theme.text)
                    .fixedSize(horizontal: false, vertical: true)
                if let minutes = StepDuration.minutes(in: text) {
                    StepTimerView(minutes: minutes, step: number, recipeTitle: recipeTitle,
                                  notificationID: notificationID, endDate: $timerEnd)
                }
            }
            .padding(24)
            .frame(maxWidth: 700, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
    }
}
