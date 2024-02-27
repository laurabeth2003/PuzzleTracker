import SwiftUI
import RealmSwift

/// View a list of all Courses in the realm. User can swipe to delete Courses.
struct CourseList: View {
    /// Determines if the view is in Preview Mode
    @Environment(\.isInCoursePreview) var isInCoursePreview
    /// Collection of all Courses objects in the realm sorted by createDate
    @ObservedResults(Course.self, sortDescriptor: SortDescriptor(keyPath: "createDate", ascending: true)) var courses
    var courseArray = Course.coursePreview
    
    var body: some View {
        ZStack {
            Image("LoginBackground")
                .resizable()
                .ignoresSafeArea()
            Color("LoginOverlay")
                .ignoresSafeArea()
            VStack {
                List {
                    /// render course preview data if isInCoursePreview is true
                    if isInCoursePreview {
                        ForEach(courseArray) { course in
                            CourseRow(course: course)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 7, leading: 17, bottom: 0, trailing: 17))
                        }
                    /// render render data if isInCoursePreview is false
                    } else {
                        ForEach(courses) { course in
                            CourseRow(course: course)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 7, leading: 17, bottom: 0, trailing: 17))
                        }
                        .onDelete(perform: $courses.remove)
                    }
                }
                .padding(.top, 10)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }
}

public extension EnvironmentValues {
    var isInCoursePreview: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        return false
        #endif
    }
}


