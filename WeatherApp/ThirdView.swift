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
    
    var stuff = ["GPS", "London", "Tampere", "New York"]
    let locationManager = CLLocationManager()
    var location: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Third view did load")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Third view did appear")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stuff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "fivedaycell")
        
        print("Load tableview cell")
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "fivedaycell", for: indexPath) as! FiveDayCell
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "someID")
        
        //cell.label.text = self.fiveDayWeatherArray?.list[indexPath.row].main.temp
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "someID")
        }
        cell!.textLabel!.text = self.stuff[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(stuff[indexPath.row])
        
        if (String(stuff[indexPath.row]) == "GPS") {
            getGPSLocation()
        }
        else {
            print("set location")
            
            //Try to check if location is real
            let geoC = CLGeocoder()
            geoC.geocodeAddressString(stuff[indexPath.row], completionHandler: { (placemarks, error) in
                //print(placemarks?.first?.location)
                if let location = placemarks?.first?.locality {
                    self.saveUserLocation(location: location)
                }
            })
            
            self.currentLocationLabel.text = "Current Location : " + (stuff[indexPath.row])
        }
    }
    
    func getGPSLocation() {
        print("Get GPS location")
        locationManager.requestAlwaysAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            print(loc.coordinate)
            let geo = CLGeocoder()
            geo.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
                self.currentLocationLabel.text = "Current Location : " + (placemarks?.first?.locality ?? "Not Found")
                
                //save user location to userdefaults
                self.saveUserLocation(location: placemarks?.first?.locality as! String)

            })
        }
        locationManager.stopUpdatingLocation()
    }
    
    //Saves last location of user
    func saveUserLocation(location: String) {
        let def = UserDefaults.standard
        def.set(location, forKey: "userLastLocation")
        def.synchronize()
    }
    
    
}
