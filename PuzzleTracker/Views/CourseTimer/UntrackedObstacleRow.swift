//
//  CompletedObstacleRow.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/13/23.
//

import SwiftUI
import RealmSwift

struct UntrackedObstacleRow: View {
    @ObservedRealmObject var obstacle: Obstacle
    @Binding var trackedObstacles: [TrackedObstacle]
    @Binding var runPoints: Int
    @Binding var totalTime: Int
    @State var showTimePicker = false
    @State var timeInMilli: Int = 0
    @State var points: Int = 0
    @State var seconds: Int = 0
    @State var minutes: Int = 0
    @State var milliseconds: Int = 0
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                HStack {
                    Text(obstacle.name).fontWeight(.bold).font(.system(size: 19))
                    Spacer()
                }
                if (obstacle.hasHalfway) {
                    HStack {
                        Text(String("Halfway:")).padding(.bottom, 1)
                        Text(obstacle.halfwayDescription ?? "")
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
                        StopwatchUnit(timeUnit: timeInMilli / 6000, unitType: "minute", size: "small")
                        Text(":").font(.system(size: 20)).offset(y: -1)
                        StopwatchUnit(timeUnit: (timeInMilli % 6000) / 100, unitType: "second", size: "small")
                        Text(".").font(.system(size: 20))
                        StopwatchUnit(timeUnit: timeInMilli % 100, unitType: "millisecond", size: "small")
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
                .onChange(of: seconds, perform: { seconds in
                    timeInMilli = (seconds * 100) + (minutes * 6000) + milliseconds
                })
                .onChange(of: minutes, perform: { minutes in
                    timeInMilli = (seconds * 100) + (minutes * 6000) + milliseconds
                })
                .onChange(of: milliseconds, perform: { milliseconds in
                    timeInMilli = (seconds * 100) + (minutes * 6000) + milliseconds
                })
            }
            Spacer()
            if (obstacle.hasHalfway) {
                Menu {
                    Button(action: {
                        points = 2
                    }, label: { Text("Complete") })
                    Button(action: {
                        points = 1
                    }, label: { Text("Halfway") })
                    Button(action: {
                        points = 0
                    }, label: { Text("Missed") })
                    
                } label: {
                    if (points == 0) {
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
                    if (points == 1) {
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
                    if (points == 2) {
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
                        points = 1
                    }, label: { Text("Complete") })
                    Button(action: {
                        points = 0
                    }, label: { Text("Missed") })
                    
                } label: {
                    if (points == 0) {
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
                    if (points == 1) {
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
            Image(systemName: "plus").resizable()
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.white)
                .padding(15)
                .onTapGesture {
                    let trackedObstacle = TrackedObstacle()
                    trackedObstacle.points = points
                    trackedObstacle.timeInMilli = timeInMilli
                    trackedObstacle.obstacle = obstacle
                    trackedObstacles.append(trackedObstacle)
                    totalTime = timeInMilli
                    runPoints += points
                    timeInMilli = 0
                    points = 0
                    seconds = 0
                    minutes = 0
                    milliseconds = 0
                }
        }
    }
    
}

#Preview {
    UntrackedObstacleRow(obstacle: Obstacle.obstacle1, trackedObstacles: .constant(TrackedObstacle.obstacles), runPoints: .constant(0), totalTime: .constant(0))
}
