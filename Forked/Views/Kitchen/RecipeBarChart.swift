// RecipeBarChart.swift
// ADVANCED FEATURE: Swift Charts. A horizontal bar chart of one value per recipe with tap-to-inspect.

import SwiftUI
import Charts

struct RecipeBarChart: View {
    struct Entry: Identifiable {
        let title: String
        let value: Double
        var id: String { title }
    }

    let title: String
    let entries: [Entry]
    let domain: ClosedRange<Double>
    let format: (Double) -> String
    @State private var selectedTitle: String?

    private var selected: Entry? {
        entries.first { $0.title == selectedTitle }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(title).font(.headline).foregroundStyle(Theme.text)
                Spacer()
                Text(selected.map { "\($0.title): \(format($0.value))" } ?? "Tap a bar for details")
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(1)
            }
            Chart(entries) { entry in
                BarMark(
                    x: .value(title, entry.value),
                    y: .value("Recipe", entry.title),
                    height: .fixed(14)
                )
                .clipShape(UnevenRoundedRectangle(bottomTrailingRadius: 4, topTrailingRadius: 4))
                .foregroundStyle(Theme.red.opacity(selectedTitle == nil || selectedTitle == entry.title ? 1 : 0.3))
                .accessibilityLabel(entry.title)
                .accessibilityValue(format(entry.value))
            }
            .chartXScale(domain: domain)
            .chartXAxis {
                AxisMarks { _ in
                    AxisGridLine().foregroundStyle(Theme.separator)
                    AxisValueLabel().foregroundStyle(Theme.secondaryText)
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisValueLabel().foregroundStyle(Theme.text)
                }
            }
            .chartYSelection(value: $selectedTitle)
            .frame(height: CGFloat(max(entries.count, 1)) * 34 + 30)
        }
        .padding(16)
        .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cardCorner))
        .overlay(RoundedRectangle(cornerRadius: Theme.cardCorner).strokeBorder(Theme.separator))
    }
}
