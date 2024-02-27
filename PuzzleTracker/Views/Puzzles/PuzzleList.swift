//
//  PuzzleList.swift
//  PuzzleTracker
//
//  Created by Laura Erickson on 2/26/24.
//

import SwiftUI
import RealmSwift

/// View a list of all Puzzles in the realm. User can swipe to delete Puzzles.
struct PuzzleList: View {
    /// Determines if the view is in Preview Mode
    @Environment(\.isInCoursePreview) var isInPuzzlePreview
    /// Collection of all Puzzle objects in the realm sorted by createDate
    @ObservedResults(PuzzleEntry.self, sortDescriptor: SortDescriptor(keyPath: "createDate", ascending: true)) var entries
    var courseArray = Course.coursePreview
    
    var body: some View {
        ZStack {
            Image("LoginBackground")
                .resizable()
                .ignoresSafeArea()
            Color("LoginOverlay")
                .ignoresSafeArea()
            VStack {
                List {
                    /// render course preview data if isInCoursePreview is true
                    if isInCoursePreview {
                        ForEach(courseArray) { course in
                            CourseRow(course: course)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 7, leading: 17, bottom: 0, trailing: 17))
                        }
                    /// render render data if isInCoursePreview is false
                    } else {
                        ForEach(courses) { course in
                            CourseRow(course: course)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 7, leading: 17, bottom: 0, trailing: 17))
                        }
                        .onDelete(perform: $courses.remove)
                    }
                }
                .padding(.top, 10)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }
}

public extension EnvironmentValues {
    var isInPuzzlePreview: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        return false
        #endif
    }
}

#Preview {
    PuzzleList()
}

