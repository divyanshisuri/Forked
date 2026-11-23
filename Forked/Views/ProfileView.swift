// The logged-in user's profile: username, role and join date, with log out.
// KAN-24 will build the chef profile on this screen.
import Foundation
import SwiftUI

struct ProfileView: View {
    let user: User
    let onLogOut: @MainActor () -> Void

    @State private var confirmingLogOut = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(user.username)
                            .font(.title2.weight(.semibold))
                            .fontDesign(.serif)
                            .foregroundStyle(Theme.text)
                        Label(user.role.title, systemImage: user.role.symbolName)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.text)
                        Text("Member since \(user.createdAt.formatted(date: .long, time: .omitted))")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .padding(.vertical, 8)
                }

                Section {
                    Button("Log Out", role: .destructive) { confirmingLogOut = true }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Profile")
            .redNavigationBar()
            .confirmationDialog("Log out of Forked?", isPresented: $confirmingLogOut, titleVisibility: .visible) {
                Button("Log Out", role: .destructive) { onLogOut() }
            }
        }
    }
}
