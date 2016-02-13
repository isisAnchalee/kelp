//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Isis Anchalee on 2/11/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate{
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    weak var delegate: FiltersViewControllerDelegate?
    var categories: [[String:String]] = []
    var switchStates: [Int:Bool] = [Int:Bool]()
    var myFilters:Filters?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onSearchBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        
        for (row, isSelected) in switchStates{
            if isSelected{
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewController!(self, didUpdateFilters: filters)
    }
    
    @IBAction func onCancelBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    
        //Instantiate the filters object to load filters
        self.myFilters = Filters(instance: Filters.instance)
        
        self.categories = YelpCategories.categories
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("in numberOfRowsInSection")
        let filter = self.myFilters!.filters[section] as Filter
        if filter.isExpanded {
            print("Returning all opts - \(filter.options.count)")
            //filter.isExpanded = false
            return filter.options.count
        } else {
            return filter.numOptsDisplayed!
        }
        
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switchStates[indexPath.row] = value
        print("filters view controller event!!")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.myFilters!.filters.count
    }
    
    
    func tableView(_ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
            return self.myFilters?.filters[section].name
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
