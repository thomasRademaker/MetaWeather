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
import Kingfisher

class WeatherViewController: UIViewController {

    private lazy var weatherView = WeatherView(frame: view.frame)
    var managedContext: NSManagedObjectContext!
    private let locationManager = CLLocationManager()
    private var locationOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureLocationManager()
        //getWeather(withKeyword: "london")
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
        searchController.searchBar.delegate = self
        
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
    
    private func updateView(forWeather weathers: ConsolidatedWeather) {
        weatherView.cityName.text = weathers.title
        
        let weather = weathers.weathers[0]
        
        weatherView.condition.text = weather.weatherStateName
        weatherView.temp.text = weather.theTemp != nil ? "\(weather.theTemp!)" : "N/A"
        weatherView.highTemp.text = "\(weather.maxTemp ?? 00)"
        weatherView.lowTemp.text = "\(weather.minTemp ?? 00)"
        
        let imageURL: URL = URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(weather.weatherStateAbbr!).png")!
        weatherView.conditionImage.kf.indicatorType = .activity
        weatherView.conditionImage.kf.setImage(with: imageURL)
    }
    
    private func getWeather(forLocation location: Location) {
        
        Alamofire.request(URL(string: "https://www.metaweather.com/api/location/\(location.woeid!)")!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                guard let status = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                
                switch status {
                case 200...299:
                    if let weatherObject = try? JSONDecoder().decode(ConsolidatedWeather.self, from: data) {
                        self.updateView(forWeather: weatherObject)
                    }
                default:
                    print("error with response status: \(status)")
                }
        }
    }
    
    private func getWeather(withLattitude lattitude: String, longitude: String) {
        //let router = MetaWeatherRouter.locationSearchWithLongitudeAndLatitude(lattitude: lattitude, longitude: longitude)
        //let router = MetaWeatherRouter.locationSearchWithCityName(cityName: "london")
        //let router = MetaWeatherRouter.getWeather(woeid: "44418")
        
        Alamofire.request(URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(lattitude),\(longitude)")!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                guard let status = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                
                switch status {
                case 200...299:
                    if let locationObject = try? JSONDecoder().decode(Array<Location>.self, from: data) {
                        self.getWeather(forLocation: locationObject[0])
                    }
                default:
                    print("error with response status: \(status)")
                }
        }
    }
    
    private func getWeather(withKeyword keyword: String) {
        Alamofire.request(URL(string: "https://www.metaweather.com/api/location/search/?query=\(keyword)")!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                guard let status = response.response?.statusCode else { return }
                guard let data = response.data else { return }
                
                switch status {
                case 200...299:
                    if let locationObject = try? JSONDecoder().decode(Array<Location>.self, from: data) {
                        self.getWeather(forLocation: locationObject[0])
                    }
                default:
                    print("error with response status: \(status)")
                }
        }
    }
}

// MARK: UISearchControllerDelegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        getWeather(withKeyword: text)
    }
}

// MARK: CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locationOnce else { return }
        guard let currentLocation = locations.last else { return }
        
        locationOnce = true
        let latitude = "\(currentLocation.coordinate.latitude)"
        let longitude = "\(currentLocation.coordinate.longitude)"
        getWeather(withLattitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
