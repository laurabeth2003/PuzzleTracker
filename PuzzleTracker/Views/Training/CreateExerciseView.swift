//
//  CreateExerciseView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/13/23.
//

import SwiftUI
import RealmSwift
import Combine

/// Instantiate a new Exercise object
/// then append it to the ``exercises`` field associated with the given Training
struct CreateExerciseView: View {
    @ObservedRealmObject var training: Training
    @Binding var isInCreateExerciseView: Bool
    
    @State private var newExercise = Exercise()
    @State private var exerciseName = ""
    @State private var durationMinutes = 0
    @State private var durationSeconds = 0
    @State private var restMinutes = 0
    @State private var restSeconds = 0
    @State private var restOn = true
    @State private var unilateral = false
    @State private var repetitions = 10
    @State private var weight = "0.0"
    @State private var sets = 3
    @State private var durationType: DurationType = DurationType.Time
    
    var body: some View {
        Form {
            Section(header: Text("Exercise Name")) {
                TextField("New Exercise", text: $exerciseName)
                VStack {
                    Picker("", selection: $durationType) {
                        Text("Time").tag(DurationType.Time)
                        Text("Repetitions").tag(DurationType.Repetitions)
                    }.pickerStyle(SegmentedPickerStyle())
                    HStack {
                        if (durationType.rawValue == "Time") {
                            TimePicker(seconds: $durationSeconds, minutes: $durationMinutes)
                        }
                        else {
                            Picker("", selection: $repetitions){
                                ForEach(1...100, id: \.self) { i in
                                    Text("\(i)").tag(i)
                                }
                            }
                            .frame(height: 100, alignment: .center)
                            .pickerStyle(WheelPickerStyle())
                            .compositingGroup()
                            .clipped()
                            Text("Repetitions")
                        }
                    }
                    Divider()
                    Toggle("Unilateral Exercise", isOn: $unilateral).tint(Color("ButtonText"))
                }
            }
            Section(header: Text("Weight")) {
                HStack {
                    TextField("Weight", text: $weight)
                        .keyboardType(.numberPad)
                        .onReceive(Just(weight)) { newValue in
                            let filtered = weight.filter { ".0123456789".contains($0) }
                            if filtered != newValue {
                                self.weight = filtered
                            }
                        }
                    Text("lbs")
                }
            }
            
            Section(header: Text("Sets")) {
                Picker("", selection: $sets){
                    ForEach(0...20, id: \.self) { i in
                        Text("\(i)").tag(i)
                    }
                }
                .frame(height: 100, alignment: .center)
                .pickerStyle(WheelPickerStyle())
                .compositingGroup()
                .clipped()
            }
            Section(header: Text("Rest Time")) {
                VStack(spacing: 0) {
                    Toggle("Rest Time", isOn: $restOn).tint(Color("ButtonText"))
                    if (restOn) {
                        Divider().padding(.top, 10)
                        TimePicker(seconds: $restSeconds, minutes: $restMinutes)
                    }
                }
            }
            Section {
                /// onSave - save the newExercise then return back to the CreateTrainingView
                Button(action: {
                    newExercise.title = exerciseName
                    newExercise.unilateral = unilateral
                    if (restOn) {
                        let restTime = (restMinutes * 60) + restSeconds
                        newExercise.restTime = restTime
                    }
                    if (durationType.rawValue == "Time") {
                        let durationTime = (durationMinutes * 60) + durationSeconds
                        newExercise.repetitionTime = durationTime
                    }
                    else {
                        newExercise.repetitions = repetitions
                    }
                    newExercise.sets = sets
                    newExercise.weight = Double(weight) ?? 0.0
                    $training.exercises.append(newExercise)
                    isInCreateExerciseView = false
                }) {
                    HStack {
                        Spacer()
                        Text("Save").foregroundColor(Color("ButtonText"))
                        Spacer()
                    }
                }
                /// onCancel - go back to the CreateTrainingView and don't save the object
                Button(action: {
                    isInCreateExerciseView = false
                }) {
                    HStack {
                        Spacer()
                        Text("Cancel").foregroundColor(Color("ButtonText"))
                        Spacer()
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitle("New Exercise")
    }
}

/// Enables the preview view for the CreateExerciseView component
struct CreateExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let isInCreateExerciseView = true
        CreateExerciseView(training: Training.training1, isInCreateExerciseView: .constant(isInCreateExerciseView))
    }
}
