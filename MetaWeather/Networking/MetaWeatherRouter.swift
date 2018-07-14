//
//  MetaWeatherRouter.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/12/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import Alamofire

enum MetaWeatherRouter: URLRequestConvertible {
    static let baseURLPath = "https://www.metaweather.com/api/location/"
    
    case locationSearchWithLongitudeAndLatitude(lattitude: String, longitude: String)
    case locationSearchWithCityName(cityName: String)
    case getWeather(woeid: String)
    case weatherForDate(woeid: String, date: String)
    
    // makeItRain is not a real endpoint. it is here to demonstate other Router abilities that this API does not require
    case makeItRain(woeid: String, inches: String)
    
    public func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            // switch statement is used because APIs can also include POST, PATCH, DELETE, etc..
            // This API happens to only need GET
            switch self {
            case .locationSearchWithLongitudeAndLatitude, .locationSearchWithCityName, .getWeather, .weatherForDate:
                return .get
            // POST example
            case .makeItRain:
                return .post
            }
        }
        
        var path: String {
            switch self {
            case .locationSearchWithLongitudeAndLatitude:
                return "search/"
            case .locationSearchWithCityName:
                return "search/"
            case .getWeather(let woeid):
                return "\(woeid)/"
            case .weatherForDate(let woeid, let date):
                return "\(woeid)/\(date)/"
            case .makeItRain(let woeid, _):
                return "\(woeid)/makeitrain/"
            }
        }
        
        let encoding: ParameterEncoding
         
         switch method {
         case .get:
            encoding = URLEncoding.default
         default:
            encoding = JSONEncoding.default
         }
        
        
        let parameters: [String: Any]? = {
            switch self {
            case .makeItRain(_ , let inches):
                return ["inches": inches]
            case .locationSearchWithLongitudeAndLatitude(let lattitude, let longitude):
                return ["lattlong" : "\(lattitude),\(longitude)"]
            case .locationSearchWithCityName(let cityName):
                return ["query" : cityName]
            default:
                return nil
            }
        }()
        
        let urlString = MetaWeatherRouter.baseURLPath + path
        let url = try urlString.asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        //request.setValue("value", forHTTPHeaderField: "HEADER") // Example of a header
        request.timeoutInterval = TimeInterval(30 * 1000)
        
        return try encoding.encode(request, with: parameters)
    }
}
