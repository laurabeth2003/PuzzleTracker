import SwiftUI
import RealmSwift

/// Render the CourseDetail when a user clicks on a item in the CourseList
/// TO DO: render a detailed outline of the course
/// TO DO: allow the user to start a course
/// TO DO: allow the user to view the leaderboard of the course
/// TO DO: allow the user to start a new wave of the course
/// TO DO: allow the user to edit some details of the course
/// TO DO: allow the user to add runners to the course
struct CourseDetail: View {
    @ObservedResults(CourseRun.self) var courseRuns
    @ObservedRealmObject var course: Course
    @State private var navigation = CourseNavigation.Summary
    @State private var filteredRuns: Results<CourseRun>?
    
    let sortProperties = [SortDescriptor(keyPath: "points", ascending: false), SortDescriptor(keyPath: "timeInMilli", ascending: true)]
    let timerUtil = TimerUtil()
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $navigation) {
                Text("Summary").tag(CourseNavigation.Summary)
                Text("Leaderboard").tag(CourseNavigation.Leaderboard)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
            if (navigation == CourseNavigation.Summary) {
                HStack {
                    Text("Time Limit:")
                    Spacer()
                    Text("\(timerUtil.secondsTominutes(seconds: course.timeLimit)):\(timerUtil.secondsToseconds(seconds: course.timeLimit))").bold()
                }
                .padding(.horizontal, 35)
                .padding(.bottom, 7)
                HStack {
                    Text("Possible Points:")
                    Spacer()
                    Text(String(totalPoints(course: course))).bold()
                }
                .padding(.horizontal, 35)
                .padding(.bottom, 10)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(course.obstacles) { obstacle in
                            VStack(spacing: 0) {
                                HStack {
                                    Text(obstacle.name).bold().font(.system(size: 18))
                                    Spacer()
                                    if (obstacle.hasHalfway) {
                                        VStack(spacing: 2) {
                                            Text("Halfway:").font(.system(size: 13)).bold()
                                            Text(obstacle.halfwayDescription!)
                                        }.padding(.trailing, 5)
                                    }
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(content: {
                                    Rectangle().fill(Color("ButtonText").opacity(0.3)).cornerRadius(10).frame(height: 50)
                                })
                            }
                            .padding(.horizontal, 20)
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                    .frame(maxHeight: 50)
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                
                Divider().padding(.top, 10)
                List {
                    ForEach(course.runners) {
                        runner in
                        ZStack {
                            let runnerIndex = course.runners.index(of: runner) ?? 0
                            OrderRow(course: course, runner: runner, runnerOrder: runnerIndex + 1)
                            NavigationLink(destination: CourseTimer(course: course, runner: runner)) {
                                EmptyView()
                            }.opacity(0)
                        }.listRowInsets(EdgeInsets())
                    }
                }
            }
            if (navigation == CourseNavigation.Leaderboard) {
                if (course.divisions.count > 0) {
                    List {
                        ForEach(course.divisions) { division in
                            //courses = 
                            //NavigationLink(destination: LeaderboardView(courseRuns: )
                            
                        }
                    }
                }
                if (course.divisions.isEmpty) {
                    if let validRuns = filteredRuns {
                        List {
                            ForEach(validRuns) {
                                run in
                                let runIndex = validRuns.index(of: run) ?? 0
                                LeaderboardRow(courseRun: run, place: runIndex + 1)
                            }.listStyle(.plain)
                        }
                    }
                            
                }
            }
        }
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            UICollectionView.appearance().contentInset.top = -25
            filteredRuns = courseRuns.where {
                $0.course == course
            }
            filteredRuns = filteredRuns?.sorted(by: sortProperties)
        }
    }
    
    func totalPoints(course: Course) -> Int {
        var totalPoints = 0
        course.obstacles.forEach { obstacle in
            totalPoints += obstacle.hasHalfway ? 2 : 1
        }
        return totalPoints
    }
}


#Preview {
    CourseDetail(course: Course.course1)
}
