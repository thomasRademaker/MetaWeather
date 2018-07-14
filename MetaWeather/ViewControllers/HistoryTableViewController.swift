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
    private var selectedSearch: Search?
    
    private let searchCellIdentifier = "searchCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        let searchFetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        fetchRequest = searchFetchRequest
        fetchAndReload()
        
        tableView?.register(HistoryCell.self, forCellReuseIdentifier: searchCellIdentifier)
    }
    
    private func setupNavBar() {
        navigationItem.title = "History"
        navigationController?.navigationBar.tintColor = .white
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
            cell.timeStampText.text = DateFormatter.localizedString(from: timeStamp as Date, dateStyle: .short, timeStyle: .short) //"\(timeStamp)"
        }

        return cell
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedSearch = selectedSearch else { return }
        
        
    }
}
