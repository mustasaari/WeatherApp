//
//  WeatherStruct.swift
//  WeatherApp
//
//  Created by Mikko Mustasaari on 09/10/2019.
//  Copyright © 2019 Mikko Mustasaari. All rights reserved.
//

import Foundation

struct WeatherStruct: Codable {
    
    var name: String
    var main: Temperature
    var weather: [Descriptions]

}

struct Temperature: Codable {
    var temp: Double
}

struct Descriptions: Codable {
    var main: String
    var description: String
    var icon: String
}
