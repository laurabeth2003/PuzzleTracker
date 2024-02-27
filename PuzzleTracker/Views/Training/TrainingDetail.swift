import SwiftUI
import RealmSwift

/// Render the TrainingDetail when a user clicks on a item in the TrainingList
/// TO DO: render a detailed outline of the workout
/// TO DO: allow the user to start a workout
/// TO DO: allow the user to view their workout history
/// TO DO: allow the user to edit some details of the workout
struct TrainingDetail: View {
    @ObservedRealmObject var training: Training
    
    var body: some View {
        Form {
            Section(header: Text("Edit Training Title")) {
                TextField("Title", text: $training.title)
            }
        }
        .navigationBarTitle("Update Training", displayMode: .inline)
    }
}

