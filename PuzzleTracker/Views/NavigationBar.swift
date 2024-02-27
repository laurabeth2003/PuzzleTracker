import SwiftUI

/// Renders the TabView that allows the user to switch between views
struct NavigationBar: View {
    var leadingBarButton: AnyView?
    
    @State var userId: String
    
    var body: some View {
        TabView {
            /// TO DO: Show ProfileView
            Text("Profile")
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("Statistics")
                }
            /// Show PuzzleView
            TrainingView(leadingBarButton: leadingBarButton, userId: userId)
                .tabItem {
                    Image(systemName: "puzzlepiece")
                    Text("Puzzles")
            }
            /// Show FriendsView
            CoursesView(leadingBarButton: leadingBarButton, userId: userId)
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Friends")
                }
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor(Color("NavigationBar"))
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.primary)
        }
        .tint(Color("ReversePrimary"))
    }
}

/// Enables the preview view for the NavigationBar component
struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(userId: "test")
    }
}
