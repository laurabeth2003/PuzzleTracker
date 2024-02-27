import RealmSwift
import Foundation

/// Generate the Training Class
class Training: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var createDate: Date
    @Persisted var exercises: List<Exercise>
    @Persisted var history: List<Comment>
    @Persisted var owner_id: String
    @Persisted var title: String
    @Persisted var type: String
}

/// Exercise Class - each Training Object will contain one to many Exercises
class Exercise: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var repetitions: Int?
    @Persisted var repetitionTime: Int?
    @Persisted var restTime: Int?
    @Persisted var sets: Int
    @Persisted var title: String
    @Persisted(originProperty: "exercises") var training: LinkingObjects<Training>
    @Persisted var unilateral: Bool
    @Persisted var weight: Double
}

/// Comment Class - each Training Object will contain one to many Comments
class Comment: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var createDate: Date
    @Persisted var text: String
}

/// Extension to provide sample Training data
extension Exercise {
    static let exercise1 = Exercise(value: ["repetitions": 5, "restTime": 90, "sets": 8, "title": "Assisted One Arm Pullups", "unilateral": true, "weight": 30.5])
}

/// Extension to provide sample Training data
extension Training {
    static let training1 = Training(value: [
        "owner_id": "test", "createDate": Date(), "title": "One Arm Pullup", "rounds": 3, "type": "Strength", "history": [Comment(value: ["createDate": Date(), "text": "This is a test history comment"])], "totalTime": 600, "roundRestTime": 120, "exercises": [Exercise(value: ["title": "Weighted Pullups", "weight": 50, "restTime": 120, "rounds": 5])]])
    static let training2 = Training(value: [
        "owner_id": "test", "createDate": Date(), "title": "One Arm Pullup", "rounds": 3, "type": "Strength", "history": [Comment(value: ["createDate": Date(), "text": "This is a test history comment"])], "totalTime": 600, "roundRestTime": 120, "exercises": [Exercise(value: ["title": "Weighted Pullups", "weight": 50, "restTime": 120, "rounds": 5])]])
    static let training3 = Training(value: [
        "owner_id": "test", "createDate": Date(), "title": "One Arm Pullup", "rounds": 3, "type": "Grip", "history": [Comment(value: ["createDate": Date(), "text": "This is a test history comment"])], "totalTime": 600, "roundRestTime": 120, "exercises": [Exercise(value: ["title": "Weighted Pullups", "weight": 50, "restTime": 120, "rounds": 5])]])
    static let trainingPreview = [training1, training2, training3]

}
