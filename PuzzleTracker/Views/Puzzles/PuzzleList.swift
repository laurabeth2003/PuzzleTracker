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
    @Environment(\.isInPuzzlePreview) var isInPuzzlePreview
    /// Collection of all Puzzle objects in the realm sorted by createDate
    @ObservedResults(PuzzleEntry.self, sortDescriptor: SortDescriptor(keyPath: "createDate", ascending: true)) var entries
    var entryArray = PuzzleEntry.entryPreview
    
    var body: some View {
        ZStack {
            Image("LoginBackground")
                .resizable()
                .ignoresSafeArea()
            Color("LoginOverlay")
                .ignoresSafeArea()
            VStack {
                List {
                    /// render puzzle preview data if isInPuzzlePreview is true
                    if isInPuzzlePreview {
                        ForEach(entryArray) { entry in
                            PuzzleRow(puzzleEntry: entry)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        }
                    /// render render data if isInPuzzlePreview is false
                    } else {
                        ForEach(entries) { entry in
                            PuzzleRow(puzzleEntry: entry)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        }
                        .onDelete(perform: $entries.remove)
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

