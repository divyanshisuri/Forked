// The app's top-level screen: the log-in gate, then tabs on iPhone or a sidebar on iPad and Mac.
import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    // Only the account's ID is remembered between launches; nothing secret is stored here.
    @AppStorage("currentAccountID") private var currentAccountID = ""
    @Query private var users: [User]
    @State private var selectedTab = 0
    @State private var showingNewPost = false

    private var currentUser: User? {
        guard !currentAccountID.isEmpty else { return nil }
        return users.first { $0.accountID.uuidString == currentAccountID }
    }

    // Present the action tab without changing selection and then reverting it.
    private var tabSelection: Binding<Int> {
        Binding {
            selectedTab
        } set: { newValue in
            if newValue == 1 {
                showingNewPost = true
            } else {
                selectedTab = newValue
            }
        }
    }

    var body: some View {
        if let currentUser {
            signedInContent(for: currentUser)
        } else {
            AuthView(onAuthenticated: startSession)
                .tint(Theme.red)
        }
    }

    /// Remembers the account that just logged in and opens the Recipes tab.
    private func startSession(for user: User) {
        selectedTab = 0
        currentAccountID = user.accountID.uuidString
    }

    /// Forgets the logged-in account, which sends the app back to the log-in screen.
    private func endSession() {
        selectedTab = 0
        currentAccountID = ""
    }

    private func signedInContent(for user: User) -> some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    List {
                        Section("Library") {
                            Button { selectedTab = 0 } label: {
                                Label("Recipes", systemImage: "fork.knife")
                                    .foregroundStyle(Theme.text)
                                    .fontWeight(selectedTab == 0 ? .semibold : .regular)
                            }
                            .listRowBackground(selectedTab == 0 ? Theme.surface : Theme.background)
                            Button { selectedTab = 2 } label: {
                                Label("Collections", systemImage: "square.stack")
                                    .foregroundStyle(Theme.text)
                                    .fontWeight(selectedTab == 2 ? .semibold : .regular)
                            }
                            .listRowBackground(selectedTab == 2 ? Theme.surface : Theme.background)
                            Button { selectedTab = 3 } label: {
                                Label("Profile", systemImage: "person.crop.circle")
                                    .foregroundStyle(Theme.text)
                                    .fontWeight(selectedTab == 3 ? .semibold : .regular)
                            }
                            .listRowBackground(selectedTab == 3 ? Theme.surface : Theme.background)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Theme.background)
                    .navigationTitle("Forked")
                    .safeAreaInset(edge: .bottom) {
                        Button { showingNewPost = true } label: {
                            Label("New Recipe", systemImage: "plus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.red)
                        .keyboardShortcut("n", modifiers: .command)
                        .padding()
                    }
                    .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 280)
                } detail: {
                    if selectedTab == 2 { CollectionsView() }
                    else if selectedTab == 3 { ProfileView(user: user, onLogOut: endSession) }
                    else { RecipeListView() }
                }
            } else {
                TabView(selection: tabSelection) {
                    RecipeListView()
                        .tabItem { Label("Recipes", systemImage: "fork.knife") }.tag(0)
                    Color.clear
                        .tabItem { Label("New Recipe", systemImage: "plus.circle") }.tag(1)
                    CollectionsView()
                        .tabItem { Label("Collections", systemImage: "square.stack") }.tag(2)
                    ProfileView(user: user, onLogOut: endSession)
                        .tabItem { Label("Profile", systemImage: "person.crop.circle") }.tag(3)
                }
            }
        }
        .tint(Theme.red)
        .sheet(isPresented: $showingNewPost) { RecipeFormView() }
    }
}
