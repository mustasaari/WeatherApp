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
    var cacheManager = CacheManager()
    
    var dataToCache: WeatherStruct?
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    let urli = "https://api.openweathermap.org/data/2.5/weather?q=London&units=metric&APPID=e5832b1e0a998a414175ccc09695ddc7"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("first view did load")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("First view did appear")
        
        //check user location from userdefaults. If not found use London as default
        city = UserDefaults.standard.string(forKey: "userLastLocation") ?? "London"
        
        //check if weather data can be found from memory. If not nil is returned from cachemanager
        let weatherFromCache = cacheManager.getWeather(city: city)
        
        if let info = weatherFromCache {
            print("WEATHER LOADED FROM CACHE \(info.name)")
            updateUI(loc: info.name, tmp: info.temperature, weather: info.weatherMain, desc: info.weatherDescription)
            
            let img = UIImage(data: info.iconData!)
            self.weatherImage.image = img
            //fetchImage(imgcode: info.icon)
            
        }
        else {
            print("weather not found from cache")
            //fetch start so spaces to plusses
            city = city.replacingOccurrences(of: " ", with: "+") //replace spaces with + for url
            let url2 = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&APPID=e5832b1e0a998a414175ccc09695ddc7"
            fetchUrl(url: url2)
            
        }
    }

    //fetch url
    func fetchUrl(url: String) {
        print("W E A T H E R D A T A  F E T C H  S T A R T E D")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url: URL? = URL(string: url)
        let task = session.dataTask(with: url!, completionHandler: doneFetching)
        task.resume()
    }
    
    //when fetch is complete
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        
        DispatchQueue.main.async(execute: {() in
            NSLog(resstr!)
            self.readJSON2(data: data)
        })
        
    }
    
    //read json func
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
            
            self.dataToCache = todo
            //cacheManager.saveCity(city: todo)
        } catch {
            print("error decoding json")
        }
    }
    
    //update ui components
    func updateUI(loc: String, tmp: Double, weather: String, desc: String) {
        self.locationLabel.text = loc
        self.temperatureLabel.text = String(tmp) + " C"
        self.descriptionLabel.text = desc
        self.weatherLabel.text = weather
    }
    
    //func for fetching weather image
    func fetchImage(imgcode: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url: URL? = URL(string: "https://openweathermap.org/img/wn/\(imgcode)@2x.png")
        let task = session.dataTask(with: url!, completionHandler: doneFetchingImage)
        task.resume()
    }
    
    //When image is fetched set it and save weather to cache
    func doneFetchingImage(data: Data?, response: URLResponse?, error: Error?) {
        
        DispatchQueue.main.async(execute: {() in
            print("image fetched")
            let img = UIImage(data: data!)
            self.weatherImage.image = img
            if let toCache = self.dataToCache {
                self.cacheManager.saveCity(city: toCache, img: data!)
            }
        })
    }
}

