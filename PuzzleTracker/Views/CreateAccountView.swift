//
//  NewAccountView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/18/23.
//

import SwiftUI
import RealmSwift

/// Log in or register users using email/password authentication
struct CreateAccountView: View {
    /// Configuration used to open the realm.
    @EnvironmentObject var appUser: TempUser
    /// manages the state of the login fields
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    /// manages whether the app state is currently handling a signup request
    @State private var isCreatingAccount = false
    /// manages showing an error alert popup
    @State private var showAlert = false
    @State private var alertText = ""
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                CreateField(fieldName: "First Name", fieldText: $firstName)
                CreateField(fieldName: "Last Name", fieldText: $lastName)
                CreateField(fieldName: "Email", fieldText: $email)
                CreateField(fieldName: "Password", fieldType: "Secure", fieldText: $password)
                CreateField(fieldName: "Confirm Password", fieldType: "Secure", fieldText: $confirmPassword)
                    HStack {
                        Spacer()
                        Button {
                            isCreatingAccount = true
                            Task {
                                await signUp(email: email, password: password, confirmPassword: confirmPassword)
                                isCreatingAccount = false
                            }
                        } label: {
                            if isCreatingAccount {
                                ProgressView().tint(.white)
                            } else {
                                Text("Create Account")
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(alertText), dismissButton: .default(Text("Ok")))
                        }
                        .disabled(isCreatingAccount)
                        .frame(width: 190, height: 50)
                        .background(Color("LoginButtons"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        Spacer()
                    }.padding(.top, 15)
                        .padding(.bottom, 25)
                }
                .padding(.horizontal, 25)
                .padding(.top, 25)
                .background(
                        Color("ReversePrimary")
                            .cornerRadius(25)
                            .ignoresSafeArea()
                            .opacity(0.65))
                .padding(10)
                .frame(maxWidth: 500)
        }.navigationTitle("Create Account")
            .tint(Color.primary)
    }
    
    /**
     Logs in with an existing user and configures the TempUser object
     - parameter email: email to login the user with.
     - parameter password: password to login the user with.
     
     Alert is shown if email/password fields are invalid
     */
    func login(email: String, password: String) async {
        do {
            let user = try await app.login(credentials: Credentials.emailPassword(email: email, password: password))
            appUser.firstName = firstName
            appUser.lastName = lastName
            appUser.email = email
            appUser.owner_id = user.id
            
        } catch {
            alertText = error.localizedDescription.capitalized
            showAlert = true
        }
    }
    
    /**
     Registers a new user with the email/password authentication provider.
     - parameter email: email to register the user with.
     - parameter password: password to register the user with.
     - parameter confirmPassword: second input of password to prevent user error
     
     Alert is shown if email/password fields are invalid
     */
    func signUp(email: String, password: String, confirmPassword: String) async {
        if (password != confirmPassword) {
            alertText = "Passwords Do Not Match"
            showAlert = true
            return
        }
        do {
            try await app.emailPasswordAuth.registerUser(email: email, password: password)
            print("Successfully registered user")
            await login(email: email, password: password)
        } catch {
            alertText = error.localizedDescription.capitalized
            showAlert = true
        }
    }
}

/// Enables the preview view for the CreateAccountView component
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
