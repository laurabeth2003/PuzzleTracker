//
//  GenderPicker.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/1/23.
//

import SwiftUI

/// Util to render a GenderPicker
struct GenderPicker: View {
    @Binding var gender: Gender
    var body: some View {
        HStack {
            Text("Gender")
            Spacer()
        }.font(Font.system(size: 14))
        HStack {
            Picker("", selection: $gender) {
                Text("Male").tag(Gender.Male)
                Text("Female").tag(Gender.Female)
            }.pickerStyle(SegmentedPickerStyle())
            Spacer()
        }
        .padding(.bottom, 5)
    }
}
