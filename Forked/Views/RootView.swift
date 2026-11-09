import SwiftUI

struct RootView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedTab = 0
    @State private var showingNewPost = false

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
                }
            }
        }
        .tint(Theme.red)
        .sheet(isPresented: $showingNewPost) { RecipeFormView() }
    }
}
