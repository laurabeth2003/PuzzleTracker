//
//  OrderRow.swift
//  NinjaFit
//
//  Created by Laura Erickson on 1/14/24.
//

import SwiftUI

struct OrderRow: View {
    @State var course: Course
    @State var runner: Runner
    @State var runnerOrder: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .frame(width: 35, height: 35)
                .foregroundStyle(Color("LeaderboardOverlay"))
                .overlay {
                    Text(String(runnerOrder)).foregroundStyle(Color.primary)
                }
                .padding(.trailing, 7)
            if (course.divisions.count > 0) {
                
            }
            if (course.divisions.count == 0) {
                Text(runner.name)
            }
            Spacer()
            VStack(spacing: 2) {
                Image(systemName: "play.fill").resizable().frame(width: 20, height: 20)
                Text("Start")
                    .font(.system(size: 11))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
    }
}

#Preview {
    OrderRow(course: Course.course1, runner: Runner.runner1, runnerOrder: 1)
}
