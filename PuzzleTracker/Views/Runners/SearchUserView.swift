//
//  SearchUserView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/26/23.
//

import SwiftUI
import RealmSwift

struct SearchUserView: View {
    var filteredUsers: Results<AppUser>?
    @Binding var isInSearchUserView: Bool
    @Binding var queryEmail: String
    @Binding var runners: [Runner]
    
    var body: some View {
        if let validUsers = filteredUsers {
            List {
                ForEach(validUsers) { user in
                    if (!runners.contains(where: { user.email == $0.email })) {
                        UserRow(user: user, isInSearchUserView: $isInSearchUserView, queryEmail: $queryEmail, runners: $runners)
                    }
                }
            }.listStyle(.plain)
        }
    }
}
