//
//  Location.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/12/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import Foundation

struct Location: Codable {
    
    //let distance: Int
    let title: String
    let locationType: String
    let woeid: Int
    let lattLong: String
    
    enum CodingKeys: String, CodingKey {
        //case distance
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}
