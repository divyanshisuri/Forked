import SwiftUI

struct RootView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedTab = 0
    @State private var showingNewPost = false

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    List {
                        Section("Library") {
                            Button { selectedTab = 0 } label: {
                                Label("Recipes", systemImage: "fork.knife")
                                    .foregroundStyle(selectedTab == 0 ? Theme.red : Theme.text)
                            }
                            Button { selectedTab = 2 } label: {
                                Label("Collections", systemImage: "square.stack")
                                    .foregroundStyle(selectedTab == 2 ? Theme.red : Theme.text)
                            }
                        }
                    }
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
                TabView(selection: $selectedTab) {
                    RecipeListView()
                        .tabItem { Label("Recipes", systemImage: "fork.knife") }.tag(0)
                    Color.clear
                        .tabItem { Label("New Recipe", systemImage: "plus.circle") }.tag(1)
                    CollectionsView()
                        .tabItem { Label("Collections", systemImage: "square.stack") }.tag(2)
                }
                .onChange(of: selectedTab) { oldValue, newValue in
                    if newValue == 1 {
                        showingNewPost = true
                        selectedTab = oldValue
                    }
                }
            }
        }
        .tint(Theme.red)
        .sheet(isPresented: $showingNewPost) { RecipeFormView() }
    }
}
