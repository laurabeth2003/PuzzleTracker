import SwiftUI
import RealmSwift

/// Util to render a Logout Button
/// Logs out user from the synchronized realm. Returns the user to the login/sign up screen.
struct LogoutButton: View {
    @State var isLoggingOut = false
    @State var error: Error?
    @State var errorMessage: ErrorMessage? = nil
    
    var body: some View {
        if isLoggingOut {
            ProgressView()
        }
        Button("Log Out") {
            guard let user = app.currentUser else {
                return
            }
            isLoggingOut = true
            Task {
                await logout(user: user)
                /// Other views are observing the app and will detect that the currentUser has changed
                isLoggingOut = false
            }
        }.disabled(app.currentUser == nil || isLoggingOut)
        .foregroundColor(.primary)
        .alert(item: $errorMessage) { errorMessage in
            Alert(
                title: Text("Failed to log out"),
                message: Text(errorMessage.errorText),
                dismissButton: .cancel()
            )
        }
    }
    
    /// Asynchronously log the user out, or display an alert with an error if logout fails.
    func logout(user: User) async {
        do {
            try await user.logOut()
            print("Successfully logged user out")
        } catch {
            print("Failed to log user out: \(error.localizedDescription)")
            self.errorMessage = ErrorMessage(errorText: error.localizedDescription)
        }
    }
}

struct ErrorMessage: Identifiable {
    let id = UUID()
    let errorText: String
}
