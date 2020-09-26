//
//  ViewController.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 26.09.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var marker: GMSMarker?
    var locationManager: CLLocationManager?
    let initialCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateLocationManager()
        configurateMap()
    }

    func configurateLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    func configurateMap() {
        mapView.camera = GMSCameraPosition.camera(withTarget: initialCoordinate, zoom: 15)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
    }

}

extension ViewController: GMSMapViewDelegate {
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let marker = GMSMarker(position: location.coordinate)
            marker.map = mapView
            self.marker = marker
            
            mapView.animate(toLocation: location.coordinate)
            
        }
    }
}
