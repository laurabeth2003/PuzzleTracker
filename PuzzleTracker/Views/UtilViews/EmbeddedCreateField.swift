//
//  EmbeddedCreateField.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/1/23.
//

import SwiftUI

/// Util view for rendering a createField which fits inside a secondary View
struct EmbeddedCreateField: View {
    @State var fieldName: String
    @Binding var fieldText: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(fieldName)
                Spacer()
            }.font(Font.system(size: 12))
            TextField(fieldName, text: $fieldText,
                      prompt: Text(fieldName).foregroundColor(Color("PlaceholderText")))
            .textInputAutocapitalization(.words)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 6))
            .autocorrectionDisabled(true)
            .frame(height: 33)
            .background(Color.primary.opacity(0.07))
            .cornerRadius(10)
            .padding(.vertical, 5)
            .padding(.trailing, 7)
        }
    }
}


/// Enables the preview view for the EmbeddedCreateField component
struct EmbeddedCreateField_Previews: PreviewProvider {
    static var previews: some View {
        EmbeddedCreateField(fieldName: "Test", fieldText: .constant("Test Value"))
    }
}
