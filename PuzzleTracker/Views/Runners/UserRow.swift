//
//  UserRow.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/26/23.
//

import SwiftUI
import RealmSwift

struct UserRow: View {
    @State var user: AppUser
    @Binding var isInSearchUserView: Bool
    @Binding var queryEmail: String
    @Binding var runners: [Runner]
    
    var body: some View {
        let age = 20
        HStack {
            VStack {
                HStack {
                    Text(user.email).fontWeight(.bold).font(.system(size: 19))
                    Spacer()
                }
                HStack {
                    Text(user.name).padding(.bottom, 1)
                    Text("•")
                    Text(String(age)).padding(.bottom, 1)
                    Spacer()
                }
            }
            Button(action: {
                isInSearchUserView = false
                queryEmail = ""
                let runner = Runner()
                runner.name = user.name
                runner.email = user.email
                runners.append(runner)
            }, label: {
                Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color("ButtonText"))
            })
        }
    }
}

/// Enables the preview view for the UserRow component
struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        let user = AppUser.user1
        UserRow(user: user, isInSearchUserView: .constant(true), queryEmail: .constant(""), runners: .constant([]))
    }
}
