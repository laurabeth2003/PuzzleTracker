//
//  CourseRun.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/11/23.
//

import Foundation
import RealmSwift

/// Generate the Course Class
class CourseRun: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var completedObstacles: List<TrackedObstacle>
    @Persisted var points: Int
    @Persisted var timeInMilli: Int
    @Persisted var course: Course?
    @Persisted var runner: Runner?
    @Persisted var start: Date
}

class TrackedObstacle: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: UUID
    @Persisted var obstacle: Obstacle?
    @Persisted var points: Int
    @Persisted var timeInMilli: Int
}

extension CourseRun {
    static let run1 = CourseRun(value: ["course": Course.course1, "points": 2, "timeInMilli": 8323, "runner": Runner.runner1, "start": Date(), "completedObstacles": [TrackedObstacle.obstacle1]])
}

extension TrackedObstacle {
    static let obstacle1 = TrackedObstacle(value: ["obstacle": Obstacle.obstacle1, "points": 2, "timeInMilli": 8323])
    static let obstacle2 = TrackedObstacle(value: ["obstacle": Obstacle.obstacle2, "points": 1, "timeInMilli": 10334])
    static let obstacle3 = TrackedObstacle(value: ["obstacle": Obstacle.obstacle3, "points": 0, "timeInMilli": 11317])
    static let obstacles = [obstacle1, obstacle2, obstacle3]
}
