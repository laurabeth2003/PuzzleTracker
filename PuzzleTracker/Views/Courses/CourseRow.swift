import SwiftUI
import RealmSwift

/// Renders a list item for the CourseList
struct CourseRow: View {
    @ObservedRealmObject var course: Course
    
    var body: some View {
        let minutes = course.timeLimit / 60
        let seconds = course.timeLimit % 60
        NavigationLink(destination: CourseDetail(course: course)) {
            VStack {
                Text(course.title).padding(.bottom, 1)
                HStack {
                    IconView(icon: "number.circle", text: String(course.obstacles.count))
                    Spacer()
                    IconView(icon: "stopwatch", text: "\(minutes):\(seconds)")
                    Spacer()
                    IconView(icon: "line.3.horizontal.decrease.circle", text: course.courseType.capitalized)
                }.padding(.horizontal, 30)
            }
        }
        .foregroundColor(Color.primary)
        .padding(13)
        .background(
            LinearGradient(colors: [Color("CourseRowGradientLeft"), Color("CourseRowGradientRight")], startPoint: .leading, endPoint: .init(x: 1, y: 0)))
        .cornerRadius(20)
        
    }
}



/// Enables the preview view for the CourseRow component
#Preview {
    CourseRow(course: Course.course1)
}


