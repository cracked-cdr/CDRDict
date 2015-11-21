//
//  MasterViewController.swift
//  CDRDict
//
//  Copyright © 2015年 cracked-cdr. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // Save history name
    private let HISTORY_USERDEFAULT_NAME = "SearchHistory"
    // When history.count eqauls it, save history.
    private let HISTORY_SAVE_COUNT = 1
    // Show history max length when launched.
    private let HISTORY_MAX = 1000

    var detailViewController: DetailViewController? = nil
    var history = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let spv = splitViewController {
            spv.preferredDisplayMode = .AllVisible
        }
        
        // Add clear hitory button.
        let clearButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "clearAll:")
        self.navigationItem.rightBarButtonItem = clearButton
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Restore history.
        if let historyArr = NSUserDefaults.standardUserDefaults().objectForKey(HISTORY_USERDEFAULT_NAME) {
            history = historyArr as! [String]
            if (history.count > HISTORY_MAX) {
                history.removeRange(Range<Int>(start: HISTORY_MAX, end: history.endIndex))
            }
        }
        
        // set keyboard notifications.
        if #available(iOS 9.0, *) {
        } else {
            let nc = NSNotificationCenter.defaultCenter()
            nc.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            nc.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        NSUserDefaults.standardUserDefaults().setObject(history, forKey: HISTORY_USERDEFAULT_NAME)
    }
    
    // MARK: - Cell Control

    // Insert cell.
    func insertNewObject(object: String) {
        if let idx = history.indexOf(object) {
            // If history has same word, Move history and cell.
            history.removeAtIndex(idx)
            history.insert(object, atIndex: 0)
            tableView.moveRowAtIndexPath(NSIndexPath(forRow: idx, inSection: 0), toIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            
        } else {
            history.insert(object, atIndex: 0)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        // Save history.
        if (history.count % HISTORY_SAVE_COUNT == 0) {
            NSUserDefaults.standardUserDefaults().setObject(history, forKey: HISTORY_USERDEFAULT_NAME)
        }
    }
    
    /// Remove all cells.
    func clearAll(sender: AnyObject) {
        let action = UIAlertAction(title: "Clear", style: .Default, handler: { (action) -> Void in
            var arr = [NSIndexPath]()
            for (var i=0; i < self.history.count; i++) {
                arr.append(NSIndexPath(forRow: i, inSection: 0))
            }
            self.history.removeAll()
            self.tableView.deleteRowsAtIndexPaths(arr, withRowAnimation: .Automatic)
            
            // Remove history.
            NSUserDefaults.standardUserDefaults().removeObjectForKey(self.HISTORY_USERDEFAULT_NAME)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let alert = UIAlertController(title: "Clear history", message: "Clear?", preferredStyle: .Alert)
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = history[indexPath.row] as String
        detailViewController?.libContainerVC.search(object)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = history[indexPath.row] as String
        cell.textLabel!.text = object
        return cell
    }
    
    // MARK: Keyboard Notification
    
    func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo, let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboard.CGRectValue().height, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        
        UIView.animateWithDuration(0.8) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        
        UIView.animateWithDuration(0.8) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

