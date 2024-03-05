//
//  PuzzleRow.swift
//  PuzzleTracker
//
//  Created by Laura Erickson on 3/5/24.
//

import SwiftUI
import RealmSwift

/// Renders a list item for the PuzzleList
struct PuzzleRow: View {
    @ObservedRealmObject var puzzleEntry: PuzzleEntry
    
    var body: some View {
        let hours = puzzleEntry.time / 3600
        let minutes = (puzzleEntry.time - (hours * 3600)) / 60
        let seconds = puzzleEntry.time % 60
        HStack {
            if let puzzleImage = puzzleEntry.image {
                Image(uiImage: UIImage(data: puzzleImage as Data)!)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .cornerRadius(20)
                    .padding(.trailing, 8)
            }
            else {
                Image("test")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .cornerRadius(20)
                    .padding(.trailing, 8)
            }
            VStack(alignment: .leading, spacing: 7) {
                Text(puzzleEntry.name)
                    .font(.headline)
                    .foregroundStyle(Color("HeaderText"))
                Text("\(hours):\(minutes):\(seconds)")
                    .font(.subheadline)
                    .foregroundStyle(Color("SubheaderText"))
        
            }
            Spacer()
        }
        .foregroundColor(Color.primary)
        .padding(13)
    }
}

#Preview {
    PuzzleRow(puzzleEntry: PuzzleEntry.entry1)
}
