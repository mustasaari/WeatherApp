//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mikko Mustasaari on 07/10/2019.
//  Copyright © 2019 Mikko Mustasaari. All rights reserved.
//

import UIKit
import CoreLocation

class ThirdView: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var newLocationTextfield: UITextField!
    @IBOutlet weak var thirdTableView: UITableView!
    
    var stuff = ["GPS", "London", "Tampere", "New York"]
    let locationManager = CLLocationManager()
    var location: String = ""
    var currentlySelectedIndexPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Third view did load")
        
        //If user locations array is found from userDefaults then load it
        if UserDefaults.standard.array(forKey: "userLastLocationArray") != nil {
            stuff = UserDefaults.standard.array(forKey: "userLastLocationArray") as! [String]
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Third view did appear")
        currentLocationLabel.text = UserDefaults.standard.string(forKey: "userLastLocation") ?? "London"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stuff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Load tableview cell")
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "someID")

        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "someID")
        }
        cell!.textLabel!.text = self.stuff[indexPath.row]
        
        return cell!
    }
    
    //set location based on user click. If GPS is clicked use GPS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(stuff[indexPath.row])
        
        if (String(stuff[indexPath.row]) == "GPS") {
            getGPSLocation()
        }
        else {
            self.currentLocationLabel.text = "Current Location : " + (stuff[indexPath.row])
            self.saveUserLocation(location: stuff[indexPath.row])
        }
        currentlySelectedIndexPath = stuff[indexPath.row]
    }
    
    //prepare to get GPS location
    func getGPSLocation() {
        print("Get GPS location")
        locationManager.requestAlwaysAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            //locationManager.requestLocation()
        }
    }
    
    //check GPS location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            print(loc.coordinate)
            let geo = CLGeocoder()
            geo.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
                self.currentLocationLabel.text = "Current Location : " + (placemarks?.first?.locality ?? "Not Found")
                
                //save user location to userdefaults
                self.saveUserLocation(location: (placemarks?.first?.locality)!)
            })
        }
        locationManager.stopUpdatingLocation()
    }
    
    //Saves last selected location of user
    func saveUserLocation(location: String) {
        let def = UserDefaults.standard
        def.set(location, forKey: "userLastLocation")
        def.synchronize()
    }
    
    //save array of user locations
    func saveUserLocationArray() {
        let def = UserDefaults.standard
        def.set(stuff, forKey: "userLastLocationArray")
        def.synchronize()
    }
    
    //When user tries to add new location, location is checked and corrected
    @IBAction func addLocationButton(_ sender: Any) {
        let newLocationName = newLocationTextfield.text
        
        let geoC = CLGeocoder()
        geoC.geocodeAddressString(newLocationName!, completionHandler: { (placemarks, error) in
            //print(placemarks?.first?.location)
            if let location = placemarks?.first?.locality {
                print("Corrected location \(location)")
                
                if (!self.stuff.contains(location)) {   //new location added
                    self.stuff.append(location)
                    self.thirdTableView.reloadData()
                    self.saveUserLocationArray()
                    self.newLocationTextfield.text = ""
                }
                else {
                    print("\(location) already exists in table")
                }
            }
            else {
                print("unreal location display error")
                self.displayLocationError()
            }
        })
    }
    
    //Remove location from user locations and then save
    @IBAction func removeLocationButton(_ sender: Any) {
        
        if let indexPath = currentlySelectedIndexPath {
            if(indexPath != "GPS") {
                if let indexOfArray = stuff.firstIndex(of: indexPath) {
                    stuff.remove(at: indexOfArray)
                    saveUserLocationArray()
                    thirdTableView.reloadData()
                }
            }
        }
    }
    
    //if location cannot be resolved show this error
    func displayLocationError() {
        let alert = UIAlertController(title: "This location cannot be found", message: "Maybe try different location?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            print("values alert")
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
}
