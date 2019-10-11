//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mikko Mustasaari on 07/10/2019.
//  Copyright © 2019 Mikko Mustasaari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var city = "London"
    var temperature = 15.0
    var weather = "Not found"
    var weatherDescription = "Not Found"
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    let urli = "https://api.openweathermap.org/data/2.5/weather?q=London&units=metric&APPID=e5832b1e0a998a414175ccc09695ddc7"
    
    //&units=metric
    //q=London

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("first view did load")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("First view did appear")
        
        //check user location from userdefaults
        city = UserDefaults.standard.string(forKey: "userLastLocation") ?? "London"
        city = city.replacingOccurrences(of: " ", with: "+")
        let url2 = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&APPID=e5832b1e0a998a414175ccc09695ddc7"
        fetchUrl(url: url2)
        //fetchImage(imgcode: "10d")
    }


    func fetchUrl(url: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url: URL? = URL(string: url)
        let task = session.dataTask(with: url!, completionHandler: doneFetching)
        task.resume()
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        
        DispatchQueue.main.async(execute: {() in
            NSLog(resstr!)
            self.readJSON2(data: data)
        })
        
    }
    
    //eka yritys mutta alla parempi koodi
    func readJSON(data: Data?) {
        let json = try? JSONSerialization.jsonObject(with: data!, options: [])
        if let dictionary = json as? [String: Any] {
            
            //iterate keys and values
            for (key, value) in dictionary {
                print(key, value)
            }
            
            //print city name "London"
            if let name = dictionary["name"] as? String {
                print(name)
            }
            
            //print temperature in london
            if let main = dictionary["main"] as? [String: Any] {
                if let temp = main["temp"] as? Double {
                    print(temp)
                }
            }
            
            if let weather = dictionary["weather"] as? [Any] {
                //print(type(of: weather))
                if let array = weather.first as? [String: Any] {
                    if let main = array["main"] {
                        print(main)
                    }
                    if let description = array["description"] {
                        print(description)
                    }
                }
                
            }
            
            
        }
    }
    
    func readJSON2 (data: Data?) {
        
        let decoder = JSONDecoder()
        
        do {
            let todo = try decoder.decode(WeatherStruct.self, from: data!)
            print(todo.name)
            print(todo.main.temp)
            print(todo.weather[0].main)
            print(todo.weather[0].description)
            print(todo.weather[0].icon)
            updateUI(loc: todo.name, tmp: todo.main.temp, weather: todo.weather[0].main, desc: todo.weather[0].description)
            self.fetchImage(imgcode: todo.weather[0].icon)
        } catch {
            print("error yay")
        }
        
    }
    
    func updateUI(loc: String, tmp: Double, weather: String, desc: String) {
        self.locationLabel.text = loc
        self.temperatureLabel.text = String(tmp) + " C"
        self.descriptionLabel.text = desc
        self.weatherLabel.text = weather
    }
    
    func fetchImage(imgcode: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url: URL? = URL(string: "https://openweathermap.org/img/wn/\(imgcode)@2x.png")
        let task = session.dataTask(with: url!, completionHandler: doneFetchingImage)
        task.resume()
    }
    
    func doneFetchingImage(data: Data?, response: URLResponse?, error: Error?) {
        //let resstr = String(data: data!, encoding: String.Encoding.utf8)
        
        DispatchQueue.main.async(execute: {() in
            //NSLog(resstr!)
            print("iamge fetched")
            var img = UIImage(data: data!)
            self.weatherImage.image = img
        })
    }
}

