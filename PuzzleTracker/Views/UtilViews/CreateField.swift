//
//  CreateAccountField.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/19/23.
//

import SwiftUI

/// Util to render a TextField with a label
struct CreateField: View {
    @State var fieldName: String
    @State var fieldType = "Regular"
    @Binding var fieldText: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(fieldName).padding(.bottom, 5)
                Spacer()
            }.font(Font.system(size: 14))
            /// rendering a Regular TextField
            if fieldType == "Regular" {
                TextField(fieldName, text: $fieldText,
                          prompt: Text(fieldName).foregroundColor(Color("PlaceholderText")))
                .textInputAutocapitalization(.never)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 6))
                .autocorrectionDisabled(true)
                .frame(height: 40)
                .background(Color.primary.opacity(0.15))
                .cornerRadius(10)
                .padding(.bottom, 5)
            }
            /// rendering a Secure TextField (for a password)
            if fieldType == "Secure" {
                SecureField(fieldName, text: $fieldText,
                          prompt: Text(fieldName).foregroundColor(Color("PlaceholderText")))
                .textInputAutocapitalization(.never)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 6))
                .autocorrectionDisabled(true)
                .frame(height: 40)
                .background(Color.primary.opacity(0.15))
                .cornerRadius(10)
                .padding(.bottom, 5)
            }
        }
    }
}

/// Enables the preview view for the CreateField component
struct CreateField_Previews: PreviewProvider {
    static var previews: some View {
        CreateField(fieldName: "Test", fieldText: .constant("Test Value"))
    }
}
