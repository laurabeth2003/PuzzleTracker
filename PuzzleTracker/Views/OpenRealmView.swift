import SwiftUI
import RealmSwift

/// Called when login completes. Opens the realm and navigates to the Items screen.
struct OpenRealmView: View {
    @AutoOpen(appId: theAppConfig.appId, timeout: 2000) var autoOpen
    @State var user: User
    @State var isInOfflineMode = false
    
    /// Configuration used to open the realm.
    @Environment(\.realmConfiguration) private var config
    /// Configuration used to open the realm.
    @EnvironmentObject var appUser: TempUser
    
    var body: some View {
        switch autoOpen {
            /// renders if Realm is in the connecting process
            case .connecting:
                ProgressView()
            /// renders if Realm is waiting for user to log in
            case .waitingForUser:
                ProgressView("Waiting for user to log in...")
            /// renders if Realm has been opened and is ready for use
            case .open(let realm):
                NavigationBar(leadingBarButton: AnyView(LogoutButton()), userId: user.id)
                    /// if offline, new items will not be written or queried from the server
                    .onChange(of: isInOfflineMode) { newValue in
                        let syncSession = realm.syncSession!
                        newValue ? syncSession.suspend() : syncSession.resume()
                    }
                    /// When the navigator bar appears, the realm should subscribe to all collections
                    /// TO DO: Putting this in ContentView does not refresh the subscriptions
                    /// TO DO: Figure out a way to refresh/add new subscriptions without readding them each time
                    .onAppear {
                        let subs = realm.subscriptions
                        subs.update {
                            subs.removeAll()
                            subs.append(QuerySubscription<PuzzleEntry>(name: Constants.puzzleEntries))
                            subs.append(QuerySubscription<AppUser>(name: Constants.appUsers))
                        }
                        /// if TempUser if configure, save it to the Realm now that Realm is synced
                        if appUser.owner_id != "" {
                            let newUser = AppUser()
                            newUser.owner_id = appUser.owner_id
                            newUser.name = appUser.firstName + " " + appUser.lastName
                            newUser.email = appUser.email
                            try! realm.write {
                                realm.add(newUser)
                            }
                        }
                    }
            /// renders if Realm data is being downloaded
            case .progress:
                ProgressView()
            /// renders if Realm failed to open
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
        }
    }
}
