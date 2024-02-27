import Foundation

enum TrainingType: String {
    case Strength
    case Grip
    case Endurance
    case Burnout
}

enum DurationType: String {
    case Time
    case Repetitions
}

enum CourseType: String, CaseIterable {
    case Speed
    case Hybrid
    case Burnout
    case Multistage
}

enum Gender: String {
    case Male
    case Female
}

enum YesNo: String {
    case Yes
    case No
}

enum CourseNavigation: String {
    case Summary
    case Leaderboard
}
