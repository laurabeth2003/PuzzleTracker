//
//  LeaderboardRow.swift
//  NinjaFit
//
//  Created by Laura Erickson on 1/14/24.
//

import SwiftUI
import RealmSwift

struct LeaderboardRow: View {
    @State var courseRun: CourseRun
    @State var place: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(place <= 3 ? Color("TopThreeOverlay") : Color("LeaderboardOverlay"))
                .overlay {
                    if (place == 1) {
                        Image(systemName: "trophy")
                            .foregroundStyle(Color("Gold"))
                    }
                    if (place == 2) {
                        Image(systemName: "trophy")
                            .foregroundStyle(Color(red: 0.50, green: 0.50, blue: 0.50))
                    }
                    if (place == 3) {
                        Image(systemName: "trophy")
                            .foregroundStyle(Color(red: 0.80, green: 0.50, blue: 0.20))
                    }
                    if (place >= 4) {
                        Text(String(place)).foregroundStyle(Color.primary)
                    }
                }
                .padding(.trailing, 10)
            VStack {
                Spacer()
                Text(courseRun.runner!.name)
                    .fontWeight(.semibold).font(.system(size: 18))
                Spacer()
            }
            .frame(minWidth: 110, alignment: .leading)
            Spacer()
            VStack {
                Text("Points:")
                    .font(.system(size: 12))
                Text(String(courseRun.points)).font(.system(size: 17))
            }
            .padding(.leading, 20)
            .frame(minWidth: 65, alignment: .leading)
            VStack {
                Text("Time:")
                    .font(.system(size: 12))
                HStack(spacing: 0.5) {
                    StopwatchUnit(timeUnit: courseRun.timeInMilli / 6000, unitType: "minute", size: "x-small")
                    Text(":").font(.system(size: 17)).offset(y: -1)
                    StopwatchUnit(timeUnit: (courseRun.timeInMilli % 6000) / 100, unitType: "second", size: "x-small")
                    Text(".").font(.system(size: 17))
                    StopwatchUnit(timeUnit: courseRun.timeInMilli % 100, unitType: "millisecond", size: "x-small")
                }
            }
            .padding(.leading, 20)
            .frame(minWidth: 90, alignment: .leading)
        }
    }
}

#Preview {
    LeaderboardRow(courseRun: CourseRun.run1, place: 1)
}
