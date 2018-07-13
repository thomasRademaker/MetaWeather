//
//  WeatherViewController.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/12/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire

class WeatherViewController: UIViewController {

    private lazy var weatherView = WeatherView(frame: view.frame)
    var managedContext: NSManagedObjectContext!
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        //configureLocationManager()
        getWeather(withKeyword: "london")
        
        //{"title":"London","location_type":"City","woeid":44418,"latt_long":"51.506321,-0.12714"}
        
        /*let locationObject = Location(title: "London", locationType: "City", woeid: 44418, lattLong: "51.506321,-0.12714")
        print("LocationObject: \(locationObject)")
        let encodedData = try? JSONEncoder().encode(locationObject)
        print("encodedData: \(String(describing: encodedData))")
        
        let jsonString = "[{\"title\":\"London\",\"location_type\":\"City\",\"woeid\":44418,\"latt_long\":\"51.506321,-0.12714\"}]"
        if let jsonData = jsonString.data(using: .utf8) {
            let locationObjectTwo = try? JSONDecoder().decode(Array<Location>.self, from: jsonData)
            print("locationObjectTwo: \(String(describing: locationObjectTwo))")
        }*/
        
        
    }
    
    override func loadView() {
        super.loadView()
        view = weatherView
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true // Navigation bar large titles
        navigationItem.title = "Meta Weather"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 0/255, green: 150/255, blue: 136/255, alpha: 1.0)
        
        let searchController = UISearchController(searchResultsController: nil) // Search Controller
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        guard let historyImage = UIImage(named: "history") else { fatalError("history image not available")}
        guard let fiveDayImage = UIImage(named: "fiveDay") else { fatalError("fiveDay image not available")}
        
        let historyItem = UIBarButtonItem(image: historyImage, style: .plain, target: self, action: #selector(history))
        historyItem.tintColor = .white
        let fiveDayItem = UIBarButtonItem(image: fiveDayImage, style: .plain, target: self, action: #selector(fiveDay))
        fiveDayItem.tintColor = .white
        navigationItem.rightBarButtonItems = [historyItem, fiveDayItem];
    }
    
    @objc private func fiveDay() {
        let fiveDayViewController = FiveDayViewController()
        navigationController?.pushViewController(fiveDayViewController, animated: true)
    }
    
    @objc private func history() {
        let historyViewController = HistoryTableViewController()
        navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    private func configureLocationManager() {
        let status  = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func updateView(forWeather weather: Weather) {
        
    }
    
    private func getWeather(forLocation location: Location) {
        Alamofire.request(URL(string: "https://www.metaweather.com/api/location/\(location.woeid)")!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                
                
                //let locationObject = try! JSONDecoder().decode(Array<Location>.self, from: response.data!)
                //self.getWeather(forLocation: locationObject[0])
                
        }
    }
    
    private func getWeather(withLattitude lattitude: String, longitude: String) {
        //let router = MetaWeatherRouter.locationSearchWithLongitudeAndLatitude(lattitude: lattitude, longitude: longitude)
        let router = MetaWeatherRouter.locationSearchWithCityName(cityName: "london")
        //let router = MetaWeatherRouter.getWeather(woeid: "44418")
        
        
        /*Alamofire.request(router)//URL(string: "https://www.metaweather.com/api/location/search/?query=london")!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            //.validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response)
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    /*let JSON = result as! NSDictionary
                    print(JSON)*/
                    
                }
                
                let locationObjectTwo = try? JSONDecoder().decode(Array<Location>.self, from: response.data!)
                print("locationObjectTwo: \(String(describing: locationObjectTwo))")
                
        }*/
        
        
       /* Alamofire.request(router).responseJSON { response in
            print("request \(router)")
            guard response.result.isSuccess else {
                print("Error while \(String(describing: response.result.error))")
                print("response: \(String(describing: response.value))")
                return
            }
            
            guard let responseJSON = response.result.value else { //as? [String: Any] else {
                print("Invalid information received from the service")
                return
            }
            
            print(responseJSON)
            
        }*/
        
        /*Alamofire.request(router).response { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")                         // response serialization result
            
            /*if let json = response.result.value {
                //print("JSON: \(json)") // serialized json response
                
                
            }*/
    
            
            
            if let data = response.data { //, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)") // original server data as UTF8 string
                
                do {
                    // Decode data to object
                    
                    let jsonDecoder = JSONDecoder()
                    let upMovie = try jsonDecoder.decode(Array<Location>.self, from: data)
                    print("THOMAS \(upMovie)")
                    
                    /*let container = try decoder.container(keyedBy: CodingKeys.self)
                    self.alcohol_content = try container.decode(String.self, forKey: .alcohol_content)
                    try super.init(from: decoder)*/
                }
                catch(let error){
                    print("ERROR WOWOW: \(error)")
                }
            }
        }*/
        
        Alamofire.request(URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(lattitude)\(longitude)")!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                
                
                let locationObject = try? JSONDecoder().decode(Array<Location>.self, from: response.data!)
                //self.getWeather(forLocation: locationObject[0])
                
        }
    }
    
    private func getWeather(withKeyword keyword: String) {
        Alamofire.request(URL(string: "https://www.metaweather.com/api/location/search/?query=\(keyword)")!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    /*let JSON = result as! NSDictionary
                     print(JSON)*/
                    
                }
                
                //let locationObjectTwo = try? JSONDecoder().decode(Array<Location>.self, from: response.data!)
                //print("locationObjectTwo: \(String(describing: locationObjectTwo))")
                let locationObject = try! JSONDecoder().decode(Array<Location>.self, from: response.data!)
                self.getWeather(forLocation: locationObject[0])
                
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard currentLocation == nil else { return }
        
        guard let currentLocation = locations.last else { return }
        
        print("Current location: \(currentLocation)")
        let latitude = "\(currentLocation.coordinate.latitude)"
        let longitude = "\(currentLocation.coordinate.longitude)"
        getWeather(withLattitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
