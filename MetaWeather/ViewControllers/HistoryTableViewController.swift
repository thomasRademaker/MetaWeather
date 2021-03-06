//
//  HistoryTableViewController.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/13/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {

    // If I had more time I would have used async fetch requests
    // and I would have used NSFetchedResultsController
    
    var managedContext: NSManagedObjectContext!
    private var fetchRequest: NSFetchRequest<Search>?
    private var searches: [Search] = []
    
    private let searchCellIdentifier = "searchCellIdentifier"
    
    lazy var activityIndicatior: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.color = .rademakerGreen()
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupActivityIndicator()
        
        let searchFetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        fetchRequest = searchFetchRequest
        fetchAndReload()
        
        tableView?.register(HistoryCell.self, forCellReuseIdentifier: searchCellIdentifier)
        tableView?.rowHeight = 44
        
    }
    
    private func setupNavBar() {
        navigationItem.title = "History"
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicatior)
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: activityIndicatior, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: activityIndicatior, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }

    private func fetchAndReload() {
        
        guard let fetchRequest = fetchRequest else {
            return
        }
        
        do {
            searches = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier, for: indexPath) as? HistoryCell else {
            fatalError("HistoryCell not dequed")
        }

        let search = searches[indexPath.row]
        cell.keywordText.text = search.keyword
        
        if let timeStamp = search.timeStamp {
            cell.timeStampText.text = DateFormatter.localizedString(from: timeStamp as Date, dateStyle: .short, timeStyle: .short)
        }

        return cell
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let keyword = searches[indexPath.row].keyword else { return }
        
        activityIndicatior.startAnimating()
        MetaWeatherAPI.getWeatherFromKeyword(keyword: keyword, completion: { result in
            self.activityIndicatior.stopAnimating()
            
            switch result {
            case .success(let data):
                if let weatherObject = try? JSONDecoder().decode(ConsolidatedWeather.self, from: data) {
                    let fiveDayPageViewController = FiveDayPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                    fiveDayPageViewController.consolidatedWeather = weatherObject
                    self.navigationController?.pushViewController(fiveDayPageViewController, animated: true)
                }
            case .failure(let error):
                self.networkErrorAlert()
                print("getWeatherWithKeyword error: \(error)")
            }
        })
    }
    
    private func networkErrorAlert() {
        let alert = UIAlertController(title: "Network error", message: "There was a network error. Please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
