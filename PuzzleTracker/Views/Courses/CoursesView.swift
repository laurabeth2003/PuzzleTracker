import SwiftUI
import RealmSwift

/// Use views to see a list of all Courses, add or delete Courses, or logout.
struct CoursesView: View {
    var leadingBarButton: AnyView?
    /// Collection of all Courses objects in the realm
    @ObservedResults(Course.self) var course

    @State var userId: String
    
    @State private var courseSummary = ""
    @State private var isInCreateCourseView = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    /// render CreateCourseView if add button is pressed
                    if isInCreateCourseView {
                        CreateCourseView(isInCreateCourseView: $isInCreateCourseView, userId: userId)
                    }
                    /// render CourseList initially
                    else {
                        CourseList()
                    }
                }
                .toolbarBackground(Color("LoginOverlay"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarItems(leading: self.leadingBarButton,
                                    trailing: HStack {
                    Button {
                        isInCreateCourseView = true
                    } label: {
                        Image(systemName: "plus")
                    }.foregroundColor(.primary)
                })
            }
            .navigationBarTitle("Courses", displayMode: .inline)
        }
        .tint(.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

/// Enables the preview view for the CoursesView component
struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(userId: "test")
    }
}

