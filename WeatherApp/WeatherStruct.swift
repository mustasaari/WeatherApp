//
//  WeatherStruct.swift
//  WeatherApp
//
//  Created by Mikko Mustasaari on 09/10/2019.
//  Copyright © 2019 Mikko Mustasaari. All rights reserved.
//

import Foundation

class WeatherStruct: Codable {
    
    var name: String
    var main: Temperature
    var weather: [Descriptions]
}

class Temperature: Codable {
    var temp: Double
}

class Descriptions: Codable {
    var main: String
    var description: String
    var icon: String
}
