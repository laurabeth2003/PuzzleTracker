//
//  CompletedObstacleRow.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/13/23.
//

import SwiftUI
import RealmSwift

struct CompletedObstacleRow: View {
    @ObservedRealmObject var completedObstacle: TrackedObstacle
    @Binding var runPoints: Int
    @Binding var totalTime: Int
    @State var showTimePicker = false
    @State var seconds: Int = 0
    @State var minutes: Int = 0
    @State var milliseconds: Int = 0
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(completedObstacle.obstacle!.name).fontWeight(.bold).font(.system(size: 19))
                    Spacer()
                }
                if (completedObstacle.obstacle!.hasHalfway) {
                    HStack {
                        Text(String("Halfway:")).padding(.bottom, 1)
                        Text(completedObstacle.obstacle!.halfwayDescription ?? "")
                        Spacer()
                    }.font(.system(size: 13))
                }
            }
            Spacer()
            VStack(spacing: 2) {
                
                Button(action: {
                    showTimePicker.toggle()
                }, label: {
                    HStack(spacing: 1) {
                        StopwatchUnit(timeUnit: completedObstacle.timeInMilli / 6000, unitType: "minute", size: "small")
                        Text(":").font(.system(size: 20)).offset(y: -1)
                        StopwatchUnit(timeUnit: (completedObstacle.timeInMilli % 6000) / 100, unitType: "second", size: "small")
                        Text(".").font(.system(size: 20))
                        StopwatchUnit(timeUnit: completedObstacle.timeInMilli % 100, unitType: "millisecond", size: "small")
                    }
                    .padding(.horizontal, 5)
                    .tint(Color.primary)
                })
                .popover(isPresented: $showTimePicker, content: {
                    VStack(spacing: 0) {
                        Text("Edit Time").font(.system(size: 15)).bold()
                        TimePickerMilli(seconds: $seconds, minutes: $minutes, milliseconds: $milliseconds, height: 80.0)
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(width: 170)
                    .presentationCompactAdaptation(.popover)
                })
                .onAppear {
                    seconds = (completedObstacle.timeInMilli % 6000) / 100
                    minutes = completedObstacle.timeInMilli / 6000
                    milliseconds = completedObstacle.timeInMilli % 100
                }
                .onChange(of: seconds, perform: { seconds in
                    completedObstacle.timeInMilli = (seconds * 100) + (minutes * 6000) + milliseconds
                })
                .onChange(of: minutes, perform: { minutes in
                    completedObstacle.timeInMilli = (seconds * 100) + (minutes * 6000) + milliseconds
                })
                .onChange(of: milliseconds, perform: { milliseconds in
                    completedObstacle.timeInMilli = (seconds * 100) + (minutes * 6000) + milliseconds
                })
                .onChange(of: completedObstacle.timeInMilli, perform: { timeInMilli in
                    totalTime = timeInMilli
                })
            }
            Spacer()
            if (completedObstacle.obstacle!.hasHalfway) {
                Menu {
                    Button(action: {
                        completedObstacle.points = 2
                    }, label: { Text("Complete") })
                    Button(action: {
                        completedObstacle.points = 1
                    }, label: { Text("Halfway") })
                    Button(action: {
                        completedObstacle.points = 0
                    }, label: { Text("Missed") })
                    
                } label: {
                    if (completedObstacle.points == 0) {
                        Image(systemName: "nosign").resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .background(content: {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                }
                                
                            })
                    }
                    if (completedObstacle.points == 1) {
                        Text("½")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .background(content: {
                                ZStack {
                                    Circle()
                                        .fill(Color("DeepYellow"))
                                }
                                
                            })
                    }
                    if (completedObstacle.points == 2) {
                        Image(systemName: "checkmark").resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .background(content: {
                                ZStack {
                                    Circle()
                                        .fill(Color.green)
                                }
                                
                            })
                    }
                }
                
            }
            else {
                Menu {
                    Button(action: {
                        completedObstacle.points = 1
                    }, label: { Text("Complete") })
                    Button(action: {
                        completedObstacle.points = 0
                    }, label: { Text("Missed") })
                    
                } label: {
                    if (completedObstacle.points == 0) {
                        Image(systemName: "nosign").resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .background(content: {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                }
                                
                            })
                    }
                    if (completedObstacle.points == 1) {
                        Image(systemName: "checkmark").resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .background(content: {
                                ZStack {
                                    Circle()
                                        .fill(Color.green)
                                }
                                
                            })
                    }
                }
                
            }
        }
        .onChange(of: completedObstacle.points, perform: { [oldValue = completedObstacle.points] newValue in
            runPoints += (newValue - oldValue)
        })
    }

}

#Preview {
    CompletedObstacleRow(completedObstacle: TrackedObstacle.obstacle1, runPoints: .constant(0), totalTime: .constant(0))
}
