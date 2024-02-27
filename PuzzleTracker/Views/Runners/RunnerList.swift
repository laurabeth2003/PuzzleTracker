//
//  SearchUserView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/23/23.
//

import SwiftUI
import RealmSwift

struct RunnerList: View {
    @ObservedResults(AppUser.self) var users
    @Binding var runners: [Runner]
    
    @State private var queryEmail = ""
    @State private var appUser = AppUser()
    @State private var isInSearchUserView = false
    @State private var showAddUser = false
    @State private var filteredUsers: Results<AppUser>?
    @State private var fullName = ""
    @State private var birthDate = Date()
    @State private var gender = Gender.Male
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            TextField("Search Users...", text: $queryEmail,
                      prompt: Text("Search Existing Users...").foregroundColor(Color("PlaceholderText")))
            .textInputAutocapitalization(.never)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 6))
            .autocorrectionDisabled(true)
            .frame(height: 40)
            .background(Color.primary.opacity(0.15))
            .cornerRadius(10)
            .padding(7)
            .padding(.bottom, 5)
            .onChange(of: queryEmail, perform: { searchField in
                if queryEmail == "" {
                    isInSearchUserView = false
                }
                else { 
                    isInSearchUserView = true
                    filteredUsers = users.where {
                        $0.email.starts(with: searchField) || $0.name.starts(with: searchField)
                    }
                }
            })
            if isInSearchUserView {
                SearchUserView(filteredUsers: filteredUsers, isInSearchUserView: $isInSearchUserView, queryEmail: $queryEmail, runners: $runners)
            }
            else {
                Button(action: {
                    showAddUser.toggle()
                }, label: {
                    HStack {
                        Text("Add Runner")
                        Spacer()
                        Image(systemName: showAddUser ? "chevron.up" : "chevron.down" )
                    }
                    .foregroundColor(Color("PlaceholderText"))
                    .padding(.horizontal, 23)
                    .padding(.top, 1)
                    .padding(.bottom, 12)
                })
                if showAddUser {
                    VStack(spacing: 5) {
                        EmbeddedCreateField(fieldName: "Full Name", fieldText: $fullName)
                        BirthDatePicker(birthDate: $birthDate)
                        GenderPicker(gender: $gender)
                        Button(action: {
                            let newRunner = Runner()
                            newRunner.name = fullName
                            newRunner.birthDate = birthDate
                            newRunner.gender = gender.rawValue
                            runners.append(newRunner)
                            showAddUser = false
                        }, label: {
                            Text("Add Runner")
                        })
                        .frame(height: 32)
                        .foregroundStyle(Color("ButtonText"))
                        .padding(.top, 3)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 7)
                }
                Divider()
                List {
                    ForEach(runners) {
                        runner in
                        RunnerRow(runner: runner)
                    }.onDelete(perform: { indexSet in runners.remove(atOffsets: indexSet)
                    })
                    .onMove(perform: move)
                }
                .navigationBarItems(trailing: EditButton().foregroundStyle(Color("ButtonText")))
                .listStyle(.plain)
            }
        }.navigationTitle("Runners")
    }
    
    func move(from source: IndexSet, to destination: Int) {
        runners.move(fromOffsets: source, toOffset: destination)
    }
}

/// Enables the preview view for the UserList component
struct RunnerList_Previews: PreviewProvider {
    static var previews: some View {
        RunnerList(runners: .constant([]))
            .environment(\.realm, AppUser.previewRealm)
    }
}
