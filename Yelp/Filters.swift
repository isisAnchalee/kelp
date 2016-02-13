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
    
    init(instance: Filters? = nil) {
        if instance != nil {
            self.copyFrom(instance!)
        }
    }
    
    func copyFrom(instance: Filters) {
        for var i = 0; i < self.filters.count; i++ {
            for var j = 0; j < self.filters[i].options.count; j++ {
                self.filters[i].options[j].selected = instance.filters[i].options[j].selected
            }
        }
    }
    
    
    class var instance: Filters {
        struct Static {
            static let instance: Filters = Filters()
        }
        return Static.instance
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