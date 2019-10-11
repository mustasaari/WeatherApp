//
//  WeatherStruct.swift
//  WeatherApp
//
//  Created by Mikko Mustasaari on 09/10/2019.
//  Copyright © 2019 Mikko Mustasaari. All rights reserved.
//

import Foundation

class WeatherStructFiveDay: Codable {
    
    var list: [WeatherFiveArray1]
    var cod: String
    
}

class WeatherFiveArray1: Codable {
    var dt_txt: String
    var main: WeatherFiveObject2
    var weather: [WeatherFiveObject3]
}

class WeatherFiveObject2: Codable {
    var temp: Double
}

class WeatherFiveObject3: Codable {
    var icon: String
    var main: String
}
