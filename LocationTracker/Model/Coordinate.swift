//
//  Coordinate.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 30.09.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

final class Coordinate : Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0

    convenience init(coord: CLLocationCoordinate2D) {
        self.init()
        self.latitude = coord.latitude
        self.longitude = coord.longitude
    }
}
