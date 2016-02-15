//
//  Filters.swift
//  Yelp
//
//  Created by Isis Anchalee on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Filters {
    
    var selectedDistanceIndex: Int = 0
    var selectedSortIndex : Int = 0
    
    
    var filters = [
        Filter(filterName: "radius_filter",
            name: "Distance",
            numOptsDisplayed: 1,
            options: [
                Option(optionName: "0.3 miles", value: "482", selected: false ),
                Option(optionName: "1 mile", value: "1609", selected: false ),
                Option(optionName: "5 miles", value: "8046", selected: false ),
                Option(optionName: "20 miles", value: "32186", selected: false )],
            isExpanded: false
        ),
        Filter(
            filterName: "deals_filter",//yelp filter name
            name: "Deal",//uitable section name
            numOptsDisplayed: 1,
            options: [
                Option(optionName: "Offering a Deal", value: "1", selected: false )
            ],
            isExpanded: false
            
        ),
        Filter(filterName: "sort",
            name: "Sort By",
            numOptsDisplayed: 1,
            options: [
                Option(optionName: "Best Match", value: "0", selected: false ),
                Option(optionName: "Distance", value: "1", selected: false ),
                Option(optionName: "Highest Rated", value: "2", selected: false )],
            isExpanded: false
        ),
        Filter(filterName: "category_filter",
            name: "Category",
            numOptsDisplayed: 3,
            options: [
                Option(optionName: "African", value: "african", selected: false ),
                Option(optionName: "American, New", value: "newamerican", selected: false ),
                Option(optionName: "American, Traditional", value: "tradamerican", selected: false ),
                Option(optionName: "Arabian", value: "arabian", selected: false ),
                Option(optionName: "Argentine", value: "argentine", selected: false ),
                Option(optionName: "Armenian", value: "armenian", selected: false )],
            isExpanded: false
        )
    ]
    
    class var sharedInstance: Filters {
        var sharedInstance: Filter?
        var token: dispatch_once_t?
        
        struct Static {
            static var sharedInstance: Filters?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.sharedInstance = Filters()
        }
        
        return Static.sharedInstance!
    }
    
    var categories: [String] {
        get {
            var categories = [String]()
            for filter in self.filters {
                if filter.name == "Category" {
                    for option in filter.options {
                        if option.selected {
                            categories.append(option.value)
                        }
                    }
                }
            }
            return categories
        }
    }
    
    var distance: Int {
        get {
            var dist: Int = 32186
            for filter in self.filters {
                if filter.name == "Distance" {
                    for option in filter.options {
                        if option.selected {
                            dist = Int(option.value)!
                        }
                    }
                }
            }
            return dist
        }
    }
    
    var deal:Bool {
        get {
            var deal: Bool = true
            for filter in self.filters {
                if filter.name == "Deal" {
                    for option in filter.options {
                        if option.selected {
                            deal = true
                        }
                    }
                }
            }
            return deal
        }
    }
    
    var sort:YelpSortMode {
        get {
            return YelpSortMode(rawValue: selectedSortIndex)!
        }
    }
    
}

class Filter {
    var name: String
    var filterName: String
    var numOptsDisplayed : Int?
    var options: Array<Option>
    var isExpanded: Bool
    
    init(filterName: String? = nil, name: String, numOptsDisplayed: Int?, options: Array<Option>, isExpanded: Bool) {
        self.filterName = filterName!
        self.name = name
        self.numOptsDisplayed = numOptsDisplayed
        self.options = options
        self.isExpanded = isExpanded
    }
}

class Option {
    var optionName: String
    var value: String
    var selected: Bool
    
    init(optionName: String, value: String, selected: Bool = false) {
        self.optionName = optionName
        self.value = value
        self.selected = selected
    }
    
}

