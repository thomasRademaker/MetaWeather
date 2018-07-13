//
//  Weather.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/12/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import Foundation

struct Weather: Codable {
    
    let id: Int?
    let weatherStateName: String?
    let weatherStateAbbr: String?
    let windDirectionCompass: String?
    let created: String?
    let applicableDate: String?
    let minTemp: Double?
    let maxTemp: Double?
    let theTemp: Double?
    let windSpeed: Double?
    let windDirection: Double?
    let airPressure: Double?
    let humidity: Int?
    let visibility: Double?
    let predictability: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity
        case visibility
        case predictability
    }
}

struct ConsolidatedWeather: Codable {
    let weathers: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case weathers = "consolidated_weather"
    }
}
