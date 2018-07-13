//
//  FiveDayViewController.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/12/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import UIKit

class FiveDayViewController: UIViewController {

    private lazy var weatherView = WeatherView(frame: view.frame)
    var weather: Weather?
    var cityName: String?
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func loadView() {
        super.loadView()
        view = weatherView
    }

    private func updateView() { // TODO: clean up optionals
        
        guard let weather = weather else { fatalError("weather is not being injected into FoveDayViewController") }
        
        weatherView.cityName.text = cityName ?? "N/A"
        
        weatherView.condition.text = weather.weatherStateName
        weatherView.temp.text = weather.theTemp != nil ? "\(weather.theTemp!)" : "N/A"
        weatherView.highTemp.text = "\(weather.maxTemp ?? 00)"
        weatherView.lowTemp.text = "\(weather.minTemp ?? 00)"
        
        let imageURL: URL = URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(weather.weatherStateAbbr!).png")!
        weatherView.conditionImage.kf.indicatorType = .activity
        weatherView.conditionImage.kf.setImage(with: imageURL)
    }
}
