//
//  PuzzleTracker.swift
//  PuzzleTracker
//
//  Created by Laura Erickson on 2/25/24.
//

import SwiftUI
import RealmSwift

/**
 This method loads app config details from a atlasConfig.plist
 Uses the loadAppConfig method from the NinjaFitConfig.swift file
*/
let theAppConfig = loadAppConfig()
let app = App(id: theAppConfig.appId, configuration: AppConfiguration(baseURL: theAppConfig.baseUrl, transport: nil))

@main
struct realmSwiftUIApp: SwiftUI.App {
    /// configuring a tempUser so it can be saved into Realm
    @StateObject var appUser: TempUser = TempUser()
    var body: some Scene {
        WindowGroup {
            ContentView(app: app)
                .environmentObject(appUser)
        }
    }
}
