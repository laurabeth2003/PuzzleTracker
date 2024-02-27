//
//  ObstacleRow.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/1/23.
//

import SwiftUI

struct DivisionRow: View {
    @Binding var division: Division
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(division.label).fontWeight(.bold).font(.system(size: 17))
                    Spacer()
                }
                HStack {
                    if ((division.minDate) != nil) {
                        Text("Age Range: " + String(ageFromDate(dateInput: division.minDate!)) + " - " + String(ageFromDate(dateInput: division.maxDate!)))
                    }
                }.font(.system(size: 14))
            }
        }
    }
    
    func ageFromDate(dateInput: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateInput, to: Date.now)
        return ageComponents.year!
    }
}

#Preview {
    DivisionRow(division: .constant(Division.division))
}
