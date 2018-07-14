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
    let searchController = UISearchController(searchResultsController: nil)
    private var consolidatedWeather: ConsolidatedWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureLocationManager()
    }
    
    override func loadView() {
        super.loadView()
        view = weatherView
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Meta Weather"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = .rademakerGreen()
        
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
        let fiveDayPageViewController = FiveDayPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        fiveDayPageViewController.consolidatedWeather = consolidatedWeather
        navigationController?.pushViewController(fiveDayPageViewController, animated: true)
    }
    
    @objc private func history() {
        let historyViewController = HistoryTableViewController()
        historyViewController.managedContext = managedContext
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
        guard weathers.weathers.count > 0 else {
            return
        }
        
        let weather = weathers.weathers[0]
        
        weatherView.condition.text = weather.weatherStateName
        weatherView.temp.text = weather.theTemp != nil ? "\(weather.theTemp!.rounded(toPlaces: 1))" : "N/A"
        weatherView.highTemp.text = weather.maxTemp != nil ? "\(weather.maxTemp!.rounded(toPlaces: 1))" : "N/A"
        weatherView.lowTemp.text = weather.minTemp != nil ? "\(weather.minTemp!.rounded(toPlaces: 1))" : "N/A"
        
        if let imageURL: URL = URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(weather.weatherStateAbbr!).png") {
            weatherView.conditionImage.kf.indicatorType = .activity
            weatherView.conditionImage.kf.setImage(with: imageURL)
        }
    }
    
    private func getWeather(router: MetaWeatherRouter) {
        weatherView.activityIndicatior.startAnimating()
        MetaWeatherAPI.getWeather(router: router, completion: { result in
            self.weatherView.activityIndicatior.stopAnimating()
            
            switch result {
            case .success(let data):
                switch router {
                case .getWeather:
                    if let weatherObject = try? JSONDecoder().decode(ConsolidatedWeather.self, from: data) {
                        self.consolidatedWeather = weatherObject
                        self.updateView(forWeather: weatherObject)
                    }
                case .locationSearchWithCityName, .locationSearchWithLongitudeAndLatitude:
                    if let locationObject = try? JSONDecoder().decode(Array<Location>.self, from: data) {
                        guard locationObject.count > 0 else {
                            self.locationReturnedNoResultsAlert()
                            return
                        }
                        guard let woeid = locationObject[0].woeid else { return }
                        self.getWeather(router: MetaWeatherRouter.getWeather(woeid: "\(woeid)"))
                    }
                default:
                    print("Default")
                }
            case .failure(let error):
                print("getWeatherWithKeyword error: \(error)")
            }
        })
    }
    
    private func locationReturnedNoResultsAlert() {
        let alert = UIAlertController(title: "No Results", message: "Your search returned no results. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: UISearchControllerDelegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        getWeather(router: MetaWeatherRouter.locationSearchWithCityName(cityName: text))
        
        let search = Search(context: managedContext)
        search.keyword = text
        search.timeStamp = NSDate()
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
        }
        
        searchController.isActive = false
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
        getWeather(router: MetaWeatherRouter.locationSearchWithLongitudeAndLatitude(lattitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
