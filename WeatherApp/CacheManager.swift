//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Mikko Mustasaari on 22/10/2019.
//  Copyright © 2019 Mikko Mustasaari. All rights reserved.
//

import Foundation

class CacheManager {
    
    //check if weather is found in cache. If not return nil
    func getWeather(city: String) -> CacheSave? {
        
        print("getweather from cache \(city)")
        let loadDirectory = self.getCacheDirectory(filename: city)
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: loadDirectory))
            let returnCache = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! CacheSave
            print(returnCache.date.timeIntervalSinceNow)
            if returnCache.date.timeIntervalSinceNow < -30 {
                //if data too old return nil
                return nil
            }
            else {
                return returnCache
            }
        } catch {
            print("error in loading")
        }
        //if not found return nil
        return nil
    }
    
    //save weather of city
    func saveCity(city: WeatherStruct, img: Data) {
        print("started saving")
        let testCity = CacheSave(name: city.name, temp: city.main.temp , weatherDesc: city.weather[0].description, weatherMain: city.weather[0].main, icon: city.weather[0].icon)
        testCity.iconData = img
        let saveDirectory = self.getCacheDirectory(filename: city.name)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: testCity, requiringSecureCoding: false)
            try data.write(to: URL(fileURLWithPath: saveDirectory))
        } catch {
            
        }
    }
    
    //get hardware cache directory
    func getCacheDirectory(filename: String) -> String {
        let directories = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheDirectory = directories[0]
        let pathWithFileName = "\(cacheDirectory)/\(filename).txt"
        return pathWithFileName
    }
}

//Class for saving weather data
class CacheSave : NSObject, NSCoding  {
    
    var name: String
    var weatherDescription: String
    var weatherMain: String
    var temperature: Double
    var icon: String
    var date: Date
    var iconData: Data?
    
    init(name: String, temp: Double, weatherDesc: String, weatherMain: String, icon: String) {
        self.name = name
        self.temperature = temp
        self.weatherDescription = weatherDesc
        self.weatherMain = weatherMain
        self.icon = icon
        self.date = Date()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "namestr") as! String
        weatherDescription = aDecoder.decodeObject(forKey: "descstr") as! String
        weatherMain = aDecoder.decodeObject(forKey: "mainstr") as! String
        icon = aDecoder.decodeObject(forKey: "iconstr") as! String
        temperature = aDecoder.decodeDouble(forKey: "tempstr")
        date = aDecoder.decodeObject(forKey: "datestr") as! Date
        iconData = aDecoder.decodeObject(forKey: "iconDatastr") as? Data
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "namestr")
        aCoder.encode(weatherDescription, forKey: "descstr")
        aCoder.encode(weatherMain, forKey: "mainstr")
        aCoder.encode(temperature, forKey: "tempstr")
        aCoder.encode(icon, forKey: "iconstr")
        aCoder.encode(date, forKey: "datestr")
        aCoder.encode(iconData, forKey: "iconDatastr")
    }
    
}
