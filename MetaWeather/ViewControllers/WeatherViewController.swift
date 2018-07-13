//
//  WeatherViewController.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/12/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import UIKit
import CoreData

class WeatherViewController: UIViewController {

    private lazy var weatherView = WeatherView(frame: view.frame)
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
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
        
    }
    
    @objc private func history() {
        
    }

}
