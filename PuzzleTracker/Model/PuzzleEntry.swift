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
}
