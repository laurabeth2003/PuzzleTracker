//
//  CourseRunSummary.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/12/23.
//

import SwiftUI
import RealmSwift

struct CourseRunSummary: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedResults(CourseRun.self) var courseRuns
    @ObservedRealmObject var course: Course
    @ObservedRealmObject var runner: Runner
    @State var completedObstacles: [TrackedObstacle] = []
    @State private var courseRun: CourseRun = CourseRun()
    @State var runPoints = 0
    @State var totalTime = 0
    @State var submitted = false
    let timerUtil = TimerUtil()
    
    var body: some View {
        VStack {
            let coursePoints = totalPoints(course: course)
            let untrackedObstacles = untrackedObstacles()
            Text(runner.name).font(.title)
            Text("Points: \(runPoints)/\(coursePoints)")
            HStack(spacing: 2) {
                StopwatchUnit(timeUnit: totalTime / 6000, unitType: "minute", size: "medium")
                Text(":").font(.system(size: 35)).offset(y: -3)
                StopwatchUnit(timeUnit: (totalTime % 6000) / 100, unitType: "second", size: "medium")
                Text(".").font(.system(size: 35))
                StopwatchUnit(timeUnit: totalTime % 100, unitType: "millisecond", size: "medium")
            }
            .padding(.horizontal, 50)
            if completedObstacles.count > 0 {
                List {
                    ForEach(completedObstacles) { obstacle
                        in CompletedObstacleRow(completedObstacle: obstacle, runPoints: $runPoints, totalTime: $totalTime)
                    }
                }
                .listStyle(.plain)
            }
            if untrackedObstacles.count > 0 {
                Text("\(untrackedObstacles.count) Untracked Obstacles").font(.title2)
                UntrackedObstacleRow(obstacle: untrackedObstacles.first!, trackedObstacles: $completedObstacles, runPoints: $runPoints, totalTime: $totalTime)
            }
            Spacer()
            Button(action: {
                let realm = courseRuns.thaw()!.realm!
                try! realm.write {
                    courseRun = realm.create(CourseRun.self, value: ["course": course, "runner": runner], update: .modified)
                    courseRun.start = Date()
                    courseRun.points = runPoints
                    courseRun.timeInMilli = totalTime
                    completedObstacles.forEach {
                        obstacle in
                        let trackedObstacle = realm.create(TrackedObstacle.self, value: ["obstacle": obstacle.obstacle!, "timeInMilli": obstacle.timeInMilli, "points": obstacle.points], update: .modified)
                        courseRun.completedObstacles.append(trackedObstacle)
                    }
                    $courseRuns.append(courseRun)
                }
                dismiss()
            }, label: {
                Text("Submit")
            })
        }
        .onAppear(perform: {
            runPoints = completedObstacles.count > 0 ? madePoints(completedObstacles: completedObstacles) : 0
            totalTime = runPoints > 0 ? completedObstacles.max { a, b in a.timeInMilli < b.timeInMilli && b.points > 0 }?.timeInMilli ?? 0 : 0
        })
        .onChange(of: totalTime, perform: { _ in
            totalTime = runPoints > 0 ? completedObstacles.max { a, b in a.timeInMilli < b.timeInMilli && b.points > 0 }?.timeInMilli ?? 0 : 0
            
        })
        .onChange(of: runPoints, perform: { _ in
            totalTime = runPoints > 0 ? completedObstacles.max { a, b in a.timeInMilli < b.timeInMilli && b.points > 0 }?.timeInMilli ?? 0 : 0
        })
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    
    func totalPoints(course: Course) -> Int {
        var totalPoints = 0
        course.obstacles.forEach { obstacle in
            totalPoints += obstacle.hasHalfway ? 2 : 1
        }
        return totalPoints
    }
    
    func madePoints(completedObstacles: [TrackedObstacle]) -> Int {
        var madePoints = 0
        completedObstacles.forEach { obstacle in
            madePoints += obstacle.points
        }
        return madePoints
    }
    
    func untrackedObstacles() -> [Obstacle] {
        let trackedObstacles = completedObstacles.map { $0.obstacle }
        return course.obstacles.filter { !trackedObstacles.contains($0) }
    }
}

#Preview {
    CourseRunSummary(course: Course.course1, runner: Runner.runner1)
}
