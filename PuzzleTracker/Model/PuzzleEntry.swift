//
//  PuzzleEntry.swift
//  PuzzleTracker
//
//  Created by Laura Erickson on 2/25/24.
//

import Foundation
import RealmSwift

/// PuzzleEntry class
class PuzzleEntry: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var time: Int
    @Persisted var name: String
    @objc var image: NSData?
}

/// Extension to provide sample Puzzle Entry data
extension PuzzleEntry {
    static let entry1 = PuzzleEntry(value: ["time": 4521, "name": "Exotic Garden"])
    static let entry2 = PuzzleEntry(value: ["time": 7921, "name": "Colorful Butterflies"])
    static let entry3 = PuzzleEntry(value: ["time": 4213, "name": "Seaside Boats"])
    static let entryPreview = [entry1, entry2, entry3]
}
