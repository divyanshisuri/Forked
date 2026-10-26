import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0
    @State private var showingNewPost = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                RecipeListView()
                    .tabItem {
                        Label("Recipes", systemImage: "fork.knife")
                    }
                    .tag(0)

                Color.clear
                    .tabItem {
                        Text("")
                    }
                    .tag(1)

                CollectionsView()
                    .tabItem {
                        Label("Collections", systemImage: "folder.fill")
                    }
                    .tag(2)
            }
            .tint(Theme.red)
            .fontDesign(.rounded)
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == 1 {
                    showingNewPost = true
                    selectedTab = oldValue
                }
            }

            Button {
                showingNewPost = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(Theme.red)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .shadow(color: Theme.red.opacity(0.5), radius: 8, y: 4)
            }
            .padding(.bottom, 2)
        }
        .fullScreenCover(isPresented: $showingNewPost) {
            RecipeFormView(parent: nil)
        }
    }
}
