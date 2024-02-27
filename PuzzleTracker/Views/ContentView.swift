import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedObject var app: RealmSwift.App
    @EnvironmentObject var appUser: TempUser

    var body: some View {
        if let user = app.currentUser {
            /// Setup configuraton so all the users subscriptions are removed initally (subscriptions are added in OpenRealmView)
            let config = user.flexibleSyncConfiguration(initialSubscriptions: { subs in
                subs.removeAll()
            })
            OpenRealmView(user: user)
                .environment(\.realmConfiguration, config)
                .environmentObject(appUser)
        } else {
            LoginView()
                .environmentObject(appUser)
        }
    }
}

