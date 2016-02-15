//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    var businesses: [Business] = []
    var filteredBusinesses: [Business]!
    var filters = Filters.sharedInstance
    var searchVar: String? = ""

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredBusinesses = businesses
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        performSearch()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if !searchText.isEmpty{
            self.searchVar = searchText
            performSearch()
            tableView.reloadData()
        }
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredBusinesses.count
    }
    
    @IBAction func onTop(sender: AnyObject) {
        self.searchBar.endEditing(true)
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        let business = filteredBusinesses[indexPath.row]
        cell.business = business
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performSearch(){
        Business.searchWithTerm(searchVar!, sort: filters.sort, categories: filters.categories, deals: filters.deal) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
        }
    }
    
    func didUpdateFilters(controller: FiltersViewController) {
        performSearch()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

}
