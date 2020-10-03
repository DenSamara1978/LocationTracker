//
//  Path.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 30.09.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

final class Path: Object {
    @objc dynamic var id: Int = 0
    let points = List<Coordinate>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func addPoint(coordinate: CLLocationCoordinate2D) {
        points.append(Coordinate(coord: coordinate))
    }
}
