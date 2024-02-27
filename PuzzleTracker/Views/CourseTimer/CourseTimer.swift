//
//  CourseTimer.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/9/23.
//

import SwiftUI
import RealmSwift

struct CourseTimer: View {
    @ObservedRealmObject var course: Course
    @ObservedRealmObject var runner: Runner
    @State private var trackedObstacles: [TrackedObstacle] = []
    @State private var obstacleIndex: Int = 0
    @State private var currentObstacle: Obstacle = Obstacle()
    @State private var millisecondsPassed: Int = 0
    @State private var timeLimit: Int = 0
    @State private var started = false
    @State private var finished = false
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        if finished || trackedObstacles.count == course.obstacles.count {
            CourseRunSummary(course: course, runner: runner, completedObstacles: trackedObstacles)
        } else {
            HStack {
                Spacer()
                VStack {
                    Text("Currently running:")
                    Text(runner.name).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Spacer()
                    TimerView(timeLimit: timeLimit, millisecondsPassed: $millisecondsPassed)
                        .onReceive(timer) {
                            _ in
                            if (millisecondsPassed / 100) == timeLimit {
                                started = false
                            }
                            if started {
                                millisecondsPassed += 1
                            }
                        }
                        .padding(22)
                    Spacer()
                    VStack {
                        if course.obstacles.count > obstacleIndex {
                            if let halfwayMark = currentObstacle.halfwayDescription {
                                Text("Obstacle \(obstacleIndex + 1)/\(course.obstacles.count)")
                                Text(currentObstacle.name).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                                Text("Halfway: \(halfwayMark.lowercased())")
                                ObstacleButton(currentObstacle: currentObstacle, buttonType: "Missed", trackedObstacles: $trackedObstacles, obstacleIndex: $obstacleIndex, millisecondsPassed: $millisecondsPassed)
                                ObstacleButton(currentObstacle: currentObstacle, buttonType: "Halfway", trackedObstacles: $trackedObstacles, obstacleIndex: $obstacleIndex,  millisecondsPassed: $millisecondsPassed)
                                ObstacleButton(currentObstacle: currentObstacle, buttonType: "Complete", trackedObstacles: $trackedObstacles, obstacleIndex: $obstacleIndex,  millisecondsPassed: $millisecondsPassed)
                                
                            }
                            else {
                                Text("Obstacle \(obstacleIndex + 1)/\(course.obstacles.count)")
                                Text(currentObstacle.name).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                                ObstacleButton(currentObstacle: currentObstacle, buttonType: "Missed", trackedObstacles: $trackedObstacles, obstacleIndex: $obstacleIndex, millisecondsPassed: $millisecondsPassed)
                                ObstacleButton(currentObstacle: currentObstacle, buttonType: "Complete", trackedObstacles: $trackedObstacles, obstacleIndex: $obstacleIndex,  millisecondsPassed: $millisecondsPassed)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .frame(maxWidth: 550)
                    .background(content: {
                        Rectangle()
                            .fill(Color.primary.opacity(0.1))
                            .cornerRadius(20)
                    })
                    .padding(.bottom, 10)
                    .padding(.horizontal, 15)
                    HStack {
                        if !started {
                            VStack {
                                Button(action: {
                                    started = false
                                    millisecondsPassed = 0
                                    obstacleIndex = 0
                                    trackedObstacles.removeAll()
                                }, label: {
                                    Image(systemName: "arrow.counterclockwise").resizable()
                                })
                                .frame(width: 25, height: 30)
                                .foregroundStyle(Color.white)
                                .padding(22)
                                .background(content: {
                                    ZStack {
                                        Circle()
                                            .fill(Color("ButtonText"))
                                        Circle()
                                            .fill(Color("ButtonText"))
                                            .blur(radius: 10)
                                    }
                                })
                                Text("Restart")
                                    .foregroundStyle(Color.primary)
                                    .font(.system(size: 14))
                            }.padding(.top, 23)
                        }
                        if started && obstacleIndex > 0 {
                            VStack {
                                Button(action: {
                                    obstacleIndex -= 1
                                    trackedObstacles.removeLast()
                                }, label: {
                                    Image(systemName: "arrow.counterclockwise").resizable()
                                })
                                .frame(width: 25, height: 30)
                                .foregroundStyle(Color.white)
                                .padding(22)
                                .background(content: {
                                    ZStack {
                                        Circle()
                                            .fill(Color("ButtonText"))
                                        Circle()
                                            .fill(Color("ButtonText"))
                                            .blur(radius: 10)
                                    }
                                })
                                Text("Reset Last")
                                    .foregroundStyle(Color.primary)
                                    .font(.system(size: 14))
                            }.padding(.top, 23)
                        }
                        Spacer()
                        VStack {
                            Button(action: {
                                if ((millisecondsPassed / 100) != timeLimit) {
                                    started.toggle()
                                }
                            }, label: {
                                started ? Image(systemName: "pause.fill").resizable().padding(.leading, 0) : Image(systemName: "play.fill").resizable().padding(.leading, 7)
                            })
                            .frame(width: 50, height: 45)
                            .foregroundStyle(Color.white)
                            .padding(25)
                            .background(content: {
                                ZStack {
                                    Circle()
                                        .fill(Color("ButtonText"))
                                    Circle()
                                        .fill(Color("ButtonText"))
                                        .blur(radius: 10)
                                }
                                
                            })
                            if (started) {
                                Text("Pause").foregroundStyle(Color.primary)
                            }
                            if (!started && millisecondsPassed == 0) {
                                Text("Start").foregroundStyle(Color.primary)
                            }
                            if (!started && millisecondsPassed > 0){
                                Text("Resume").foregroundStyle(Color.primary)
                            }
                        }
                        
                        Spacer()
                        if !started {
                            VStack {
                                Button(action: {
                                    finished = true
                                }, label: {
                                    Image(systemName: "flag.checkered").resizable()
                                })
                                .frame(width: 25, height: 30)
                                .foregroundStyle(Color.white)
                                .padding(22)
                                .background(content: {
                                    ZStack {
                                        Circle()
                                            .fill(Color("ButtonText"))
                                        Circle()
                                            .fill(Color("ButtonText"))
                                            .blur(radius: 10)
                                    }
                                })
                                Text("Finish")
                                    .foregroundStyle(Color.primary)
                                    .font(.system(size: 14))
                            }.padding(.top, 23)
                        }
                        if started && obstacleIndex > 0 {
                            VStack {
                                Button(action: {
                                    print("")
                                }, label: {
                                    Image(systemName: "flag.checkered").foregroundColor(Color.clear)
                                })
                                .frame(width: 25, height: 30)
                                .foregroundStyle(Color.clear)
                                .padding(22)
                            }.padding(.top, 23)
                        }
                    }
                    .padding(.bottom, 5)
                    .padding(.horizontal, 65)
                }
                Spacer()
                
            }
            .onAppear {
                currentObstacle = course.obstacles[obstacleIndex]
                timeLimit = course.timeLimit
            }
            .onChange(of: obstacleIndex, perform: { obstacleIndex in
                if course.obstacles.count > obstacleIndex {
                    currentObstacle = course.obstacles[obstacleIndex]
                } else {
                    started = false
                }
            })
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}

#Preview {
    CourseTimer(course: Course.course1, runner: Runner.runner1)
}
