//
//  DatePicker.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/30/23.
//

import SwiftUI

/// Util to render a BirthDatePicker
struct BirthDatePicker: View {
    @Binding var birthDate: Date
    
    var body: some View {
        HStack {
            Text("Birth Date")
            Spacer()
        }.font(Font.system(size: 14))
        HStack {
            DatePicker(
                "",
                selection: $birthDate,
                displayedComponents: [.date]
            ).labelsHidden()
                .frame(height: 40)
            Spacer()
        }
        .padding(.bottom, 5)
    }
}
