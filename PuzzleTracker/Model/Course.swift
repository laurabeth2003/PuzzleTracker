import RealmSwift
import Foundation

/// Generate the Course Class
class Course: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ageGroupCutoffDate: Date?
    @Persisted var divisions: List<Division>
    @Persisted var courseType: String
    @Persisted var createDate: Date
    @Persisted var location: Location?
    @Persisted var obstacles: List<Obstacle>
    @Persisted var owner_id: String
    @Persisted var runners: List<Runner>
    @Persisted var timeLimit: Int
    @Persisted var title: String
}

/// Division that the Course should be split into
class Division: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var includePro: Bool
    @Persisted var isMale: Bool
    @Persisted var isFemale: Bool
    @Persisted var label: String
    @Persisted var maxDate: Date?
    @Persisted var minDate: Date?
}

/// Location where the Course is being hosted
class Location: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var latitude: Double
    @Persisted var longitude: Double
}

/// Runner object
class Runner: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var birthDate: Date
    @Persisted var email: String
    @Persisted var gender: String
    @Persisted var name: String
}

/// Obstacle object
class Obstacle: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var halfwayDescription: String?
    @Persisted var hasHalfway: Bool
    @Persisted var name: String
    
}

extension Division {
    static let division = Division(value: ["includePro": true, "isMale": true, "isFemale": false, "label": "15U (Male)", "minDate": Date(), "maxDate": Date()])
}

extension Obstacle {
    static let obstacle1 = Obstacle(value: ["name": "Laches", "hasHalfway": true, "halfwayDescription": "Touch third bar"])
    static let obstacle2 = Obstacle(value: ["name": "Steps", "hasHalfway": false])
    static let obstacle3 = Obstacle(value: ["name": "Nunchucks", "hasHalfway": true, "halfwayDescription": "Touch fourth nunchuck"])
    static let obstacleArray = [obstacle1, obstacle2, obstacle3]
}

extension Runner {
    static let runner1 = Runner(value: ["gender": "Female", "name": "Laura Erickson", "birthDate": Date(timeIntervalSince1970: 1000000000), "email": "lauraerickson@gmail.com"])
}

/// Extension to provide sample Course data
extension Course {
    static let course1 = Course(value: ["owner_id": "test", "createDate": Date(), "title": "course1", "obstacles": Obstacle.obstacleArray, "courseType": "speed", "difficulty": 3, "timeLimit": 232, "runners": [Runner.runner1]])
    static let course2 = Course(value: ["owner_id": "test", "createDate": Date(), "title": "course1", "courseType": "speed", "difficulty": 3, "timeLimit": 232])
    static let course3 = Course(value: ["owner_id": "test", "createDate": Date(), "title": "course1", "courseType": "speed", "difficulty": 3, "timeLimit": 232])
    static let coursePreview = [course1, course2, course3]

}
