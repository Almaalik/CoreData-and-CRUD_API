//
//  LocationViewController.swift
//  CoreData and API
//
//  Created by DB-MBP-012 on 11/05/24.
//

import UIKit
import CoreLocation
import MapKit


class LocationViewController: UIViewController {
    
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    
    var clLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    func initialSetup() {
        
        clLocationManager = CLLocationManager()
        clLocationManager.delegate = self
        clLocationManager.requestWhenInUseAuthorization()
        
        locationMapView.delegate = self
        locationMapView.showsUserLocation = true
        
    }
    
    //MARK: - Button Action
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: - Location Manager Delegate

extension LocationViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            clLocationManager.startUpdatingLocation()
        default:
            debugPrint("User Denied the location access")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let userLatitude = location.coordinate.latitude
        let userLongitude = location.coordinate.longitude
        longitudeLbl.text = "Longitude : \(userLongitude)"
        latitudeLbl.text = "Latitude : \(userLatitude)"
        clLocationManager.stopUpdatingLocation()
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        locationMapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Failed to get user's location: \(error.localizedDescription)")
    }
}

