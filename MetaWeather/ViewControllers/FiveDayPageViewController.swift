//
//  FiveDayPageViewController.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/13/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import UIKit

class FiveDayPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var consolidatedWeather: ConsolidatedWeather?
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        self.dataSource = self
        self.delegate = self
        let initialPage = 0
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        // pageControl
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    private func setupNavBar() {
        navigationItem.title = "5 Day"
        navigationController?.navigationBar.tintColor = .white
    }
    
    private lazy var pages: [UIViewController] = {
        let cityName = consolidatedWeather?.title
        
        let dayOne = FiveDayViewController()
        dayOne.weather = consolidatedWeather?.weathers[0]
        dayOne.cityName = cityName
        
        let dayTwo = FiveDayViewController()
        dayTwo.weather = consolidatedWeather?.weathers[1]
        dayTwo.cityName = cityName
        
        let dayThree = FiveDayViewController()
        dayThree.weather = consolidatedWeather?.weathers[2]
        dayThree.cityName = cityName
        
        let dayFour = FiveDayViewController()
        dayFour.weather = consolidatedWeather?.weathers[3]
        dayFour.cityName = cityName
        
        let dayFive = FiveDayViewController()
        dayFive.weather = consolidatedWeather?.weathers[4]
        dayFive.cityName = cityName
        
        return [dayOne, dayTwo, dayThree, dayFour, dayFive]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return self.pages.last
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.index(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}
