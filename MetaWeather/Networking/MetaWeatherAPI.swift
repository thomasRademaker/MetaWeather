//
//  MetaWeatherAPI.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/13/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import Foundation
import Alamofire

enum Result<Value> {
    case success(Value)
    case failure(MetaWeatherError)
}

enum MetaWeatherError: Error {
    case networkError
    // If I had more time I would have created more specific MetaWeatherErrors
    // and I would have had better error handling
}

struct MetaWeatherAPI {
    
    static func getWeather(router: MetaWeatherRouter, completion: @escaping (Result<Data>) -> Void) {
        Alamofire.request(router)
            .responseJSON { response in
                
                guard let status = response.response?.statusCode else {
                    completion(.failure(.networkError))
                    return
                }
                
                guard let data = response.data else {
                    completion(.failure(.networkError))
                    return
                }
                
                switch status {
                case 200...299:
                    completion(Result.success(data))
                default:
                    // If I had more time I would have handled individual status codes differently
                    print("error with response status: \(status)")
                    completion(.failure(.networkError))
                }
        }
    }
    
    static func getWeatherFromKeyword(keyword: String, completion: @escaping (Result<Data>) -> Void) {
        MetaWeatherAPI.getWeather(router: MetaWeatherRouter.locationSearchWithCityName(cityName: keyword), completion: { result in
            switch result {
            case .success(let data):
                if let locationObject = try? JSONDecoder().decode(Array<Location>.self, from: data) {
                    guard locationObject.count > 0 else {
                        completion(.failure(.networkError))
                        return
                    }
                    guard let woeid = locationObject[0].woeid else {
                        completion(.failure(.networkError))
                        return
                    }
                    MetaWeatherAPI.getWeather(router: MetaWeatherRouter.getWeather(woeid: "\(woeid)"), completion: { result in
                        completion(result)
                    })
                } else {
                    completion(.failure(.networkError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
