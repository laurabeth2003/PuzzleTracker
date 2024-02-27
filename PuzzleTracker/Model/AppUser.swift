//
//  User.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/18/23.
//

import Foundation
import RealmSwift

/// Generate the TempUser Class (this will hold the user data before realm is configured)
class TempUser: ObservableObject {
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var owner_id: String = ""
}


/// Generate the AppUser Class
class AppUser: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var email: String
    @Persisted var owner_id: String
    @Persisted var name: String
    
    ///Allows for preview data to be configured
    static var previewRealm: Realm {
        var realm: Realm
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        do {
            realm = try Realm(configuration: config)
            // Check to see whether the in-memory realm already contains sampe AppUsers.
            // If it does, we'll just return the existing realm.
            // If it doesn't, we'll add a Person append the Dogs.
            let realmObjects = realm.objects(AppUser.self)
            if realmObjects.count == 3 {
                return realm
            } else {
                try realm.write {
                    for user in userPreview {
                        realm.add(user)
                    }
                }
                return realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}

/// Extension to provide sample AppUser data
extension AppUser {
    static let user1 = AppUser(value: ["owner_id": "user1", "email": "user1@gmail.com", "name": "Jim Smith"])
    static let user2 = AppUser(value: ["owner_id": "user2", "email": "user2@gmail.com", "name": "Jimmy Johnson"])
    static let user3 = AppUser(value: ["owner_id": "user3", "email": "user3@gmail.com", "name": "Violet Stone"])
    static let userPreview = [user1, user2, user3]
}


