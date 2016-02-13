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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredBusinesses = businesses

        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        definesPresentationContext = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({(business: Business) -> Bool in
            return business.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        tableView.reloadData()
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredBusinesses.count
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
    
    
    func didUpdateFilters(controller: FiltersViewController) {
        if self.searchBar.text != "" {
            print("didUpdateFilters called")
            print("Distance is \(Filters.instance.distance)")
            print("Deal is \(Filters.instance.deal)")
            
            Business.searchWithTerm("Restaurants", sort: .Distance, categories: Filters.instance.categories, deals: Filters.instance.deal) { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

}
