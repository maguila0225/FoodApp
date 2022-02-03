//
//  LocationVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var confirmAddressButton: UIButton!
    @IBOutlet weak var address: UILabel!
    
    let searchBarPadding = UIView()
    let searchBarImage = UIImageView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkLocationServices()
    }

    @IBAction func confirmAddressAction(_ sender: Any) {
        
    }
}

extension LocationVC{
    func setupView(){
        backgroundView.layer.cornerRadius = 10
        confirmAddressButton.layer.cornerRadius = 10
        searchBar.addSubview(searchBarPadding)
        searchBarPadding.addSubview(searchBarImage)
        
        searchBarPadding.frame = CGRect(x: 0,
                                        y: 0,
                                        width: 30,
                                        height: searchBar.frame.size.height)
        searchBarImage.frame = CGRect(x: 6, y: 5, width: 20, height: 20)
        searchBarImage.image = UIImage(systemName: "magnifyingglass")
        searchBar.setLeftPaddingPoints(30)
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
        else{
            NSLog("Location Services are disabled")
        }
    }
    
    func checkLocationAuthorization(){
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .authorizedAlways:
            break
        case .restricted:
            // Show alert that location permission is restricted
            break
        case .denied:
            // display alert turn on permisions for the app
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            NSLog("Unrecognized authorizationStatus")
        }
        
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 3000, longitudinalMeters: 3000)
            map.setRegion(region, animated: true)
        }
    }
}

extension LocationVC: CLLocationManagerDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Do Stuff
    }
}

