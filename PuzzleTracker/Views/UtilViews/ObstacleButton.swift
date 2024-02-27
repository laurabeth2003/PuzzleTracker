//
//  ObstacleButton.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/10/23.
//

import SwiftUI
import RealmSwift

/// Util view for setting the points and time value of a TrackedObstacle
struct ObstacleButton: View {
    @ObservedRealmObject var currentObstacle: Obstacle
    @State var buttonType: String
    @Binding var trackedObstacles: [TrackedObstacle]
    @Binding var obstacleIndex: Int
    @Binding var millisecondsPassed: Int
    
    var body: some View {
        Button(action: {
            var trackedObstacle = TrackedObstacle()
            trackedObstacle.obstacle = currentObstacle
            trackedObstacle.timeInMilli = millisecondsPassed
            print("Adding obstacle: \(currentObstacle)")
            /// setting the points depending on what part of the obstacle was made
            if currentObstacle.hasHalfway {
                switch buttonType {
                    case "Missed": trackedObstacle.points = 0
                    case "Halfway": trackedObstacle.points = 1
                    case "Complete": trackedObstacle.points = 2
                    default: trackedObstacle.points = 0
                }
            }
            else {
                switch buttonType {
                    case "Missed": trackedObstacle.points = 0
                    case "Complete": trackedObstacle.points = 1
                    default: trackedObstacle.points = 0
                }
            }
            trackedObstacles.append(trackedObstacle)
            obstacleIndex += 1
        }, label: {
            if (buttonType == "Missed") {
                HStack {
                    Text("Missed")
                    Image(systemName: "nosign").foregroundStyle(Color.red)
                }
            }
            if (buttonType == "Halfway") {
                HStack {
                    Text("Halfway")
                    Text("½")
                        .fontWeight(.heavy)
                        .foregroundStyle(Color("DeepYellow"))
                }
            }
            if (buttonType == "Complete") {
                HStack {
                    Text("Complete")
                    Image(systemName: "checkmark").foregroundStyle(Color.green)
                }
            }
        })
        .foregroundStyle(Color.primary)
        .padding(10)
        .frame(maxWidth: 550)
        .background(content: {
            Rectangle()
                .fill(Color.primary.opacity(0.1))
                .cornerRadius(10)
        })
        .padding(.horizontal, 10)
    }
}
