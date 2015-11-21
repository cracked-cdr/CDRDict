//
//  SuggestTableView.swift
//  CDRDict
//
//  Copyright © 2015年 cracked-cdr. All rights reserved.
//

import UIKit

class SuggestTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var suggests = [String]()
    
    var tapSuggest: ( (String) -> Void )? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        self.delegate   = self
        
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 0.5
    }
    
    func showSuggests(dataArray: [String]?, search: String? = nil) {
        suggests.removeAll()
        
        guard let dataArr = dataArray else {
            reloadData()
            return
        }
        
        if (search == nil) {
            suggests = dataArr
        } else {
            for data in dataArr {
                if (data.hasPrefix(search!)) {
                    suggests.append(data)
                }
            }
        }
        
        reloadData()
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if let tap = tapSuggest, let suggest = cell?.textLabel?.text {
            tap(suggest)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggests.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = suggests[indexPath.row] as String
        cell.textLabel!.text = object
        
        return cell
    }
}
