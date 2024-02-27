//
//  LeaderboardView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 2/14/24.
//

import SwiftUI

struct LeaderboardView: View {
    @Binding var courseRuns: [CourseRun]
    
    var body: some View {
        List {
            ForEach(courseRuns) {
                run in
                let runIndex = courseRuns.firstIndex(of: run) ?? 0
                LeaderboardRow(courseRun: run, place: runIndex + 1)
            }.listStyle(.plain)
        }
    }
}

#Preview {
    LeaderboardView(courseRuns: .constant([CourseRun.run1]))
}
