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

    let searchBarImage = UIImageView()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 45000
    var previousLocation = CLLocation()
    
    var userAddress = Address()
    var userCoordinate = CLLocation()
    var selectionDelegate: PassLocationDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkLocationServices()
        getAddress()
    }
    
    @IBAction func confirmAddressAction(_ sender: Any) {
        selectionDelegate.passLocation(userAddress: userAddress)
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func searchStart(_ sender: Any) {
     
    }
    @IBAction func searchFieldTouched(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LocationSearchVC") as! LocationSearchVC
        present(vc, animated: true, completion: nil)
    }
}

protocol PassLocationDelegate {
    func passLocation (userAddress: Address)
}

extension LocationVC{
    // MARK: - Setup View
    func setupView(){
        map.delegate = self
        confirmAddressButton.layer.cornerRadius = 10
        backgroundView.layer.cornerRadius = 20
        searchBar.setLeftPaddingPoints(30)
        searchBar.textAlignment = .left
        searchBarImage.image = UIImage(systemName: "magnifyingglass")
        searchBarImage.frame = CGRect(x: view.frame.size.width * (6/375),
                                      y: view.frame.size.width * (8/375),
                                      width: view.frame.size.width * (20/375),
                                      height: view.frame.size.width * (20/375))
        searchBar.addSubview(searchBarImage)
        
    }
    

   // MARK: - Check Location Authorization
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
            startTrackingUserLocation()
            break
        case .authorizedAlways:
            break
        case .restricted:
            NSLog("App has restricted access to location")
            break
        case .denied:
            NSLog("user has denied permission to use the app")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            NSLog("Unrecognized authorizationStatus")
        }
    }
    
    //MARK: - Get User Location from Map
    func startTrackingUserLocation() {
        map.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: map)
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let latitude = map.centerCoordinate.latitude
        let longitude = map.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getAddress(){
        let center = getCenterLocation(for: map)
        userAddress.longitude = center.coordinate.longitude
        userAddress.latitude = center.coordinate.latitude
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(center) {[weak self] (placemarks, error) in
            guard let self = self else { return }
            if let _ = error {
                NSLog("error: \(error!)")
                return
            }
            guard let placemark = placemarks?.first else {
                print("placemark is empty")
                return
            }
            DispatchQueue.main.async {
                self.userAddress.streetNumber = placemark.subThoroughfare ?? ""
                self.userAddress.streetName = placemark.thoroughfare ?? ""
                self.userAddress.district = placemark.subLocality ?? ""
                self.userAddress.city = placemark.locality ?? ""
                self.userAddress.postalCode = placemark.postalCode ?? ""
                self.address.text = "\(self.userAddress.streetNumber) \(self.userAddress.streetName), \(self.userAddress.district) \(self.userAddress.city)"
            }
        }
    }
}

// MARK: - Location Manager Delegate
extension LocationVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

// MARK: - Map View Delegate
extension LocationVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: map)
        guard center.distance(from: previousLocation) > 10 else { return }
        self.previousLocation = center
    }
}
