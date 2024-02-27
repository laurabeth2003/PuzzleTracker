import SwiftUI
import RealmSwift

/// Log in using email/password authentication
struct LoginView: View {
    @EnvironmentObject var appUser: TempUser
    /// manages the state of the login and password fields
    @State private var email = ""
    @State private var password = ""

    /// manages whether the app state is currently handling a login request
    @State private var isLoggingIn = false
    /// manages whether the CreateAccountView should show
    @State private var isInCreateAccountView = false
    /// manages showing an error alert popup
    @State private var showAlert = false
    @State private var alertText = ""

    var body: some View {
        NavigationView {
            /// checks whether the user should see the CreateAccountView instead
            if isInCreateAccountView {
                CreateAccountView()
                    .environmentObject(appUser)
                
            }
            else {
                VStack {
                    ZStack {
                        Color("Background")
                            .ignoresSafeArea()
                        VStack {
                            Text("Puzzle Tracker")
                                .font(Font.system(size: 55))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        VStack {
                            CreateField(fieldName: "Email", fieldText: $email)
                            CreateField(fieldName: "Password", fieldType: "Secure", fieldText: $password)
                            Button {
                                isLoggingIn = true
                                Task.init {
                                    await login(email: email, password: password)
                                    isLoggingIn = false
                                }
                            } label: {
                                if isLoggingIn {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Log In")
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text(alertText), dismissButton: .default(Text("Ok")))
                            }
                            .disabled(isLoggingIn)
                            .frame(width: 190, height: 50)
                            .background(Color("LoginButtons"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.top, 10)
                            HStack {
                                Rectangle()
                                    .frame(height: 1)
                                Text("or")
                                Rectangle()
                                    .frame(height: 1)
                            }
                            .foregroundColor(Color("LoginButtons"))
                            NavigationLink(destination: CreateAccountView()) {
                                Text("Create Account")
                            }
                            .frame(width: 190, height: 50)
                            .background(Color("LoginButtons"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .padding(30)
                        .background(
                            Color("ReversePrimary")
                                .cornerRadius(25)
                                .ignoresSafeArea()
                                .opacity(0.65))
                        .padding(10)
                        .frame(maxWidth: 500)
                    }
                    
                }
            }
        }.tint(.primary)
            .onAppear {
                print(appUser.owner_id)
            }.navigationViewStyle(StackNavigationViewStyle())
    }

    /**
     Logs in with an existing user. Resets the TempUser ownerId
     - parameter email: email to login the user with.
     - parameter password: password to login the user with.

     Alert is shown if email/password fields are invalid
     */
    func login(email: String, password: String) async {
        do {
            let user = try await app.login(credentials: Credentials.emailPassword(email: email, password: password))
            appUser.owner_id = ""
            print("Successfully logged in user: \(user)")
        } catch {
            alertText = error.localizedDescription.capitalized
            showAlert = true
        }
    }
}

/// Enables the preview view for the LoginView component
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let appUser: TempUser = TempUser()
        LoginView()
            .environmentObject(appUser)
    }
}
