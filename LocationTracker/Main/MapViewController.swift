//
//  ViewController.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 26.09.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var trackingActionButton: UIBarButtonItem!
    @IBOutlet weak var router: MapRouter!
    
    private var beginBackgroundTask: UIBackgroundTaskIdentifier?
    private var realmNotification: NotificationToken?

    private var locationManager: CLLocationManager?
    private let initialCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    private var isTracking = false
    
    private var path = Path()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundTask()
        configurateLocationManager()
        configurateMap()
    }
    
    func configureBackgroundTask() {
        beginBackgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.beginBackgroundTask!)
            self.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
        }
    }

    func configurateLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    func configurateMap() {
        mapView.camera = GMSCameraPosition.camera(withTarget: initialCoordinate, zoom: 15)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
    }
    
    func startTracking() {
        isTracking = true
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        path = Path()
        locationManager?.startUpdatingLocation()
        trackingActionButton.title = "Завершить"
    }
    
    func stopTracking() {
        locationManager?.stopUpdatingLocation()
        isTracking = false
        trackingActionButton.title = "Начать"
    }
    
    func saveTracking() {
        removeRealmPath()
        saveRealmPath()
    }
    
    @IBAction func trackingAction(_ sender: Any) {
        if (isTracking) {
            stopTracking()
            saveTracking()
        } else {
            startTracking()
        }
    }
    
    @IBAction func prevTracking(_ sender: Any) {
        if (isTracking) {
            let alert = UIAlertController(title: "Внимание!", message: "Необходимо остановить трекинг!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Завершить", style: .default) { [weak self](action) in
                self?.stopTracking()
                self?.loadRealmPath()
            }
            let cancelAction = UIAlertAction(title: "Продолжить", style: .cancel) { (action) in
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            loadRealmPath()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toLaunch()
    }
    
    private func loadRealmPath() {
        do {
            let realm = try Realm()
            let pathes = realm.objects(Path.self)
            let path = pathes.first ?? Path()
            routePath = GMSMutablePath()
            var coord = CLLocationCoordinate2D()
            path.points.forEach { coordinate in
                coord = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                routePath?.add(coord)
            }
            route?.path = routePath
            mapView.animate(toLocation: coord)
        } catch {
            print ( error.localizedDescription )
        }
    }

    private func removeRealmPath() {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveRealmPath() {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(path)
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isTracking { return }
        if let location = locations.first {
            routePath?.add(location.coordinate)
            route?.path = routePath
            path.addPoint(coordinate: location.coordinate)
            mapView.animate(toLocation: location.coordinate)
            
        }
    }
}
