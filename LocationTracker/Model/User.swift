//
//  User.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 03.10.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""

    convenience init(_login: String, _password: String) {
        self.init()
        self.login = _login
        self.password = _password
    }

    override static func primaryKey() -> String? {
        return "login"
    }
}
