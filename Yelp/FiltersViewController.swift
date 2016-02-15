//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Isis Anchalee on 2/11/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate{
    optional func didUpdateFilters(controller: FiltersViewController)
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: FiltersViewControllerDelegate?
    var categories: [[String:String]] = []
    var switchStates: [Int:Bool] = [Int:Bool]()
    var myFilters:Filters?
    var expanded = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onSearchBtn(sender: AnyObject) {
        Filters.instance.copyFrom(self.myFilters!)
        self.delegate?.didUpdateFilters!(self)
        dismissViewControllerAnimated(true, completion: nil)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("in numberOfRowsInSection")
        let filter = self.myFilters!.filters[section] as Filter
        if filter.isExpanded {
            print("Returning all opts - \(filter.options)")
            //filter.isExpanded = false
            return filter.options.count
        } else {
            return filter.numOptsDisplayed!
        }
        
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        let filter = self.myFilters!.filters[indexPath.section] as Filter
        let option = filter.options[indexPath.row]
        cell.textLabel!.text = option.optionName
        
        if filter.name == "Deal" || filter.name == "Category" {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let switchView = UISwitch(frame: CGRectZero)
            switchView.on = option.selected
            switchView.onTintColor = UIColor(red: 73.0/255.0, green: 134.0/255.0, blue: 231.0/255.0, alpha: 1.0)
            switchView.addTarget(self, action: "handleSwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            cell.accessoryView = switchView
            
        } else if filter.name == "Distance" || filter.name == "Sort By" {
            if filter.isExpanded {
                let option = filter.options[indexPath.row]
                cell.textLabel!.text = option.optionName
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
                }
            } else {
                var selectedIndex: Int = 0
                if filter.name == "Distance" {
                    selectedIndex = (myFilters?.selectedDistanceIndex)!
                } else if filter.name == "Sort By" {
                    selectedIndex = (myFilters?.selectedSortIndex)!
                }
                cell.textLabel!.text = filter.options[selectedIndex].optionName
                cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
            }
            
        }
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switchStates[indexPath.row] = value
        print(switchStates)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.myFilters!.filters.count
    }
    
    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
            return self.myFilters?.filters[section].name
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filter = self.myFilters!.filters[indexPath.section] as Filter
        
        if filter.name == "Distance" || filter.name == "Sort By" && !filter.isExpanded {
            filter.isExpanded = true
            // Sending the results back to main queue to update UI using the fetched data
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            
        }
        
        if filter.isExpanded {
            if filter.name == "Distance" {
                let oldSelectedDistance = myFilters?.selectedDistanceIndex
                if oldSelectedDistance != indexPath.row {
                    let oldIndex = NSIndexPath(forRow: oldSelectedDistance!, inSection: indexPath.section)
                    myFilters?.selectedDistanceIndex = indexPath.row
                    let option = filter.options[indexPath.row]
                    option.selected = true
                    self.tableView.reloadRowsAtIndexPaths([indexPath, oldIndex], withRowAnimation: .Automatic)
                    
                }
            } else if filter.name == "Sort By" {
                let oldSelectedSort = myFilters?.selectedSortIndex
                if oldSelectedSort != indexPath.row {
                    let oldIndex = NSIndexPath(forRow: oldSelectedSort!, inSection: indexPath.section)
                    myFilters?.selectedSortIndex = indexPath.row
                    self.tableView.reloadRowsAtIndexPaths([indexPath, oldIndex], withRowAnimation: .Automatic)
                    
                }
            }
        }
        
    }
    
    func handleSwitchValueChanged(switchView: UISwitch) -> Void {
        let cell = switchView.superview as! UITableViewCell
        if let indexPath = self.tableView.indexPathForCell(cell) {
            let filter = self.myFilters!.filters[indexPath.section] as Filter
            let option = filter.options[indexPath.row]
            option.selected = switchView.on
        }
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
