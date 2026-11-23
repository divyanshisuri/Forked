// OnboardingView.swift
// ADVANCED FEATURE: First-launch onboarding. Four swipeable pages introducing what Forked does.

import SwiftUI

struct OnboardingView: View {
    static let storageKey = "hasSeenOnboarding"

    struct Page: Identifiable {
        let id: Int
        let systemImage: String
        let title: String
        let message: String
    }

    static let pages = [
        Page(id: 0, systemImage: "fork.knife", title: "Welcome to Forked",
             message: "A cookbook where every recipe can grow into a family of variations."),
        Page(id: 1, systemImage: "arrow.triangle.branch", title: "Fork Any Recipe",
             message: "Make it vegan, spicier or quicker. Your fork credits the original and says what changed."),
        Page(id: 2, systemImage: "frying.pan", title: "Cook Step by Step",
             message: "Scale servings, build a shopping list, then cook hands-free with big steps and timers."),
        Page(id: 3, systemImage: "chart.bar.xaxis", title: "Chefs and Home Cooks",
             message: "Chefs publish and track how their recipes are rated and forked. Home cooks cook, fork and collect.")
    ]

    let onFinish: () -> Void
    @State private var page = 0

    private var isLastPage: Bool { page == Self.pages.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("Skip", action: onFinish)
                    .foregroundStyle(Theme.secondaryText)
                    .opacity(isLastPage ? 0 : 1)
            }
            .padding()
            TabView(selection: $page) {
                ForEach(Self.pages) { page in
                    VStack(spacing: 24) {
                        Image(systemName: page.systemImage)
                            .font(.system(size: 72, weight: .light))
                            .foregroundStyle(Theme.red)
                            .frame(height: 120)
                            .accessibilityHidden(true)
                        Text(page.title)
                            .font(.largeTitle)
                            .fontDesign(.serif)
                            .multilineTextAlignment(.center)
                        Text(page.message)
                            .font(.title3)
                            .foregroundStyle(Theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 480)
                    }
                    .padding(32)
                    .tag(page.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            Button {
                if isLastPage { onFinish() } else { withAnimation { page += 1 } }
            } label: {
                Text(isLastPage ? "Get Started" : "Next").frame(maxWidth: 420)
            }
            .buttonStyle(.red)
            .padding(24)
            .accessibilityIdentifier("onboardingNext")
        }
        .background(Theme.background)
        .tint(Theme.red)
    }
}
