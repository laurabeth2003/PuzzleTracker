//
//  CreateTrainingView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/13/23.
//

import SwiftUI
import RealmSwift

/// Instantiate a new Training object
/// then append it to the ``training`` collection to add it to the Training list.
struct CreateTrainingView: View {
    @ObservedResults(Training.self) var trainings
    
    @Binding var isInCreateTrainingView: Bool
    @State var userId: String
    
    @State private var newTraining: Training = Training()
    @State private var isInCreateExerciseView = false
    @State private var selectedType = TrainingType.Burnout
    @State private var workoutName = ""
    
    var body: some View {
        NavigationView {
            /// checks whether the user should see the CreateExerciseView instead
            if isInCreateExerciseView {
                CreateExerciseView(training: newTraining, isInCreateExerciseView: $isInCreateExerciseView)
            }
            else {
                Form {
                    Section(header: Text("Workout Name")) {
                        TextField("New Workout", text: $workoutName)
                    }
                    Section(header: Text("Exercises")) {
                        List {
                            ForEach(newTraining.exercises) { exercise in NavigationLink(destination: EditExerciseView(exercise: exercise), label: { Text(exercise.title) }
                            )
                            }.onDelete(perform: $newTraining.exercises.remove)
                        }
                        Button(action: {
                            isInCreateExerciseView = true
                        }) {
                            HStack {
                                Spacer()
                                Text("New Exercise")
                                Spacer()
                            }
                        }
                        .opacity(0.0)
                        .overlay {
                            HStack {
                                Spacer()
                                Text("New Exercise").foregroundColor(Color("ButtonText"))
                                Spacer()
                            }
                        }
                    }
                    Picker("Workout Type", selection: $selectedType) {
                        Text("Burnout").tag(TrainingType.Burnout)
                        Text("Endurance").tag(TrainingType.Endurance)
                        Text("Grip").tag(TrainingType.Grip)
                        Text("Strength").tag(TrainingType.Strength)
                    }
                    Section {
                        /// onSave - save the newTraining then return back to the TrainingView
                        Button(action: {
                            newTraining.owner_id = userId
                            newTraining.title = workoutName
                            newTraining.type = selectedType.rawValue
                            newTraining.createDate = Date()
                            $trainings.append(newTraining)
                            isInCreateTrainingView = false
                        }) {
                            HStack {
                                Spacer()
                                Text("Save").foregroundColor(Color("ButtonText"))
                                Spacer()
                            }
                        }
                        /// onCancel - go back to the TrainingView and don't save the object
                        Button(action: {
                            isInCreateTrainingView = false
                        }) {
                            HStack {
                                Spacer()
                                Text("Cancel").foregroundColor(Color("ButtonText"))
                                Spacer()
                            }
                        }
                    }
                }.navigationBarTitle("New Training")
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

/// Enables the preview view for the CreateTrainingView component
struct CreateTrainingView_Previews: PreviewProvider {
    static var previews: some View {
        let isInCreateTrainingView = true
        CreateTrainingView(isInCreateTrainingView: .constant(isInCreateTrainingView), userId: "test")
    }
}
