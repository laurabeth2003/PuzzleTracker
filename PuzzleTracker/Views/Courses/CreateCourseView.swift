import SwiftUI
import RealmSwift

/// Instantiate a new Course object, let the user input a ``courseName``, and then
/// append it to the ``courses`` collection to add it to the Course list.
struct CreateCourseView: View {
    @ObservedResults(Course.self) var courses
    @Binding var isInCreateCourseView: Bool
    @State var userId: String
    
    @State private var newCourse: Course = Course()
    @State private var obstacles: [Obstacle] = []
    @State private var runners: [Runner] = []
    @State private var divisions: [Division] = []
    @State private var isInAllObstaclesView = false
    @State private var courseName = ""
    @State private var selectedType = CourseType.Hybrid
    @State private var obstacleName = ""
    @State private var timeLimitMinutes = 0
    @State private var timeLimitSeconds = 0
    @State private var hasDivisions = false
    @State private var hasGenderDivisions = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Course Name")) {
                        TextField("New Course", text: $courseName)
                    }
                    Section(header: Text("Obstacles")) {
                        NavigationLink(destination: ObstacleList(obstacles: $obstacles)) {
                            let obstacleConfigText = obstacles.count > 0 ? "(\(obstacles.count)) " : ""
                                Text("\(obstacleConfigText)Configure Obstacles").foregroundColor(Color("ButtonText"))
                            }
                        
                    }
                    Section(header: Text("Runners")) {
                        NavigationLink(destination: RunnerList(runners: $runners)) {
                            HStack {
                                let runnerConfigText = runners.count > 0 ? "(\(runners.count)) " : ""
                                Text("\(runnerConfigText)Configure Runners").foregroundColor(Color("ButtonText"))
                                Spacer()
                                
                            }
                        }
                        
                    }
                    Section(header: Text("Divisions")) {
                        Toggle("Enable Divisions", isOn: $hasDivisions).foregroundStyle(Color("ButtonText"))
                        if (hasDivisions) {
                            Toggle("Male and Female Divisions?", isOn: $hasGenderDivisions)
                            NavigationLink(destination: DivisionList(divisions: $divisions, hasGenderDivisions: $hasGenderDivisions)) {
                                HStack {
                                    let divisionConfigText = divisions.count > 0 ? "(\(divisions.count)) " : ""
                                    Text("\(divisionConfigText)Configure Divisions").foregroundColor(Color("ButtonText"))
                                    Spacer()
                                    
                                }
                            }
                        }
                        
                    }
                    
                    Section(header: Text("Course Type")) {
                        Picker(selection: $selectedType,
                               label: Text("Course Type").foregroundStyle(Color("ButtonText")),
                               content: {
                                ForEach(CourseType.allCases, id: \.self) { courseType in
                                    Text(courseType.rawValue).tag(courseType)
                            }
                        })
                    }
                    Section(header: Text("Time Limit")) {
                        HStack {
                            Picker("", selection: $timeLimitMinutes){
                                ForEach(0..<60, id: \.self) { i in
                                    Text("\(i)").tag(i)
                                }
                            }
                            .frame(height: 100, alignment: .center)
                            .pickerStyle(WheelPickerStyle())
                            .compositingGroup()
                            .clipped()
                            Text("min")
                            Picker("", selection: $timeLimitSeconds){
                                ForEach(0..<60, id: \.self) { i in
                                    Text("\(i)").tag(i)
                                }
                            }
                            .frame(height: 100, alignment: .center)
                            .pickerStyle(WheelPickerStyle())
                            .compositingGroup()
                            .clipped()
                            Text("sec")
                        }
                    }
                    Section {
                        /// onSave - save the newCourse then return back to the CoursesView
                        Button(action: {
                            newCourse.owner_id = userId
                            newCourse.title = courseName
                            newCourse.courseType = selectedType.rawValue
                            newCourse.createDate = Date()
                            newCourse.timeLimit = (timeLimitMinutes * 60) + timeLimitSeconds
                            if (divisions.count > 0) {
                                divisions.forEach {
                                    division in
                                    newCourse.divisions.append(division)
                                }
                            }
                            obstacles.forEach {
                                obstacle in
                                newCourse.obstacles.append(obstacle)
                            }
                            runners.forEach {
                                runner in
                                newCourse.runners.append(runner)
                            }
                            $courses.append(newCourse)
                            isInCreateCourseView = false
                        }) {
                            HStack {
                                Spacer()
                                Text("Save").foregroundColor(Color("ButtonText"))
                                Spacer()
                            }
                        }
                        /// onCancel - go back to the CoursesView and don't save the object
                        Button(action: {
                            isInCreateCourseView = false
                        }) {
                            HStack {
                                Spacer()
                                Text("Cancel").foregroundColor(Color("ButtonText"))
                                Spacer()
                            }
                        }
                    }
                    
                }
                .navigationBarTitle("New Course")
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .tint(.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

/// Enables the preview view for the CreateCourseView component
struct CreateCourseView_Previews: PreviewProvider {
    static var previews: some View {
        let isInCreateCourseView = true
        CreateCourseView(isInCreateCourseView: .constant(isInCreateCourseView), userId: "test")
    }
}
