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
}

struct MetaWeatherAPI {
    
    static func getWeather(router: MetaWeatherRouter, completion: @escaping (Result<Data>) -> Void) {
        // FIXME: New York crashed app
        Alamofire.request(router)
            .responseJSON { response in
                
                guard let status = response.response?.statusCode else {
                    completion(Result.failure(.networkError))
                    return
                }
                
                guard let data = response.data else {
                    completion(Result.failure(.networkError))
                    return
                }
                
                switch status {
                case 200...299:
                    completion(Result.success(data))
                default:
                    print("error with response status: \(status)")
                    completion(Result.failure(.networkError))
                }
        }
    }
}
