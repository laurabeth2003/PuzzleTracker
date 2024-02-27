//
//  CreateExerciseView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/13/23.
//

import SwiftUI
import RealmSwift
import Combine

/// edit an Exercise object
struct EditExerciseView: View {
    @ObservedRealmObject var exercise: Exercise

    @State private var durationMinutes = 0
    @State private var durationSeconds = 0
    @State private var restMinutes = 0
    @State private var restSeconds = 0
    
    @State private var restOn = false
    @State private var weight = "0"
    @State private var repetitions = 0
    @State private var durationType: DurationType = DurationType.Repetitions
    
    var body: some View {
        Form {
            Section(header: Text("Exercise Name")) {
                TextField("New Exercise", text: $exercise.title)
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
                    Toggle("Unilateral Exercise", isOn: $exercise.unilateral).tint(Color("ButtonText"))
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
                        .onAppear {
                            weight = String(exercise.weight)
                        }
                        .onChange(of: weight, perform: { weight in
                            exercise.weight = Double(weight) ?? 0
                        })
                    Text("lbs")
                }
            }
            
            Section(header: Text("Sets")) {
                Picker("", selection: $exercise.sets){
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
                        HStack {
                            TimePicker(seconds: $restSeconds, minutes: $restMinutes)
                        }
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitle("Edit Exercise")
        /// setting the rest, repetitions, and selectors to be match the current Exercise object
        .onAppear(perform: {
            if exercise.repetitionTime != nil {
                durationType = DurationType.Time
            }
            if exercise.restTime != nil {
                restOn = true
            }
            repetitions = exercise.repetitions ?? 5
            durationMinutes = (exercise.repetitionTime ?? 0) / 60
            durationSeconds = (exercise.repetitionTime ?? 0) % 60
            restMinutes = (exercise.restTime ?? 0) / 60
            restSeconds = (exercise.restTime ?? 0) % 60
        })
        /// determining what kind of repetitions the exercise has and whether the rest toggle is on
        .onDisappear(perform: {
            if (restOn) {
                exercise.restTime = (restMinutes * 60) + restSeconds
            }
            else {
                exercise.restTime = nil
            }
            if (durationType.rawValue == "Time") {
                exercise.repetitionTime = (durationMinutes * 60) + durationSeconds
                exercise.repetitions = nil
            }
            else {
                exercise.repetitions = repetitions
                exercise.repetitionTime = nil
            }
        })
    }
}

/// Enables the preview view for the CreateExerciseView component
struct EditExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        EditExerciseView(exercise: Exercise.exercise1)
    }
}
