//
//  DetailViewController.swift
//  CDRDict
//
//  Copyright © 2015年 cracked-cdr. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var dictSearch: UISearchBar!
    
    @IBOutlet weak var suggestView: UIView!
    @IBOutlet weak var historySuggest: SuggestTableView!
    @IBOutlet weak var dictionarySuggest: SuggestTableView!
    @IBOutlet weak var libContainerViewBottom: NSLayoutConstraint!

    var libContainerVC: LibContainerViewController! // iOS Dictionary VC Container
    
    private var masterVC: MasterViewController! // show History VC
    
    private let textChecker = UITextChecker()   // Spell Checker (en-US only)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictSearch.delegate = self
        
        // find and set MasterViewController.
        if let split = splitViewController,
            let navi = split.viewControllers[0] as? UINavigationController,
            let mas = navi.topViewController as? MasterViewController {
                
                masterVC = mas
        }
        
        // find ContainerViewController.
        for vc in childViewControllers {
            if (vc is LibContainerViewController) {
                libContainerVC = vc as! LibContainerViewController
                break
            }
        }
        
        // set Suggest tap action.
        let tapSuggest = { (suggest: String) in
            self.dictSearch.text = suggest
            self.searchBarSearchButtonClicked(self.dictSearch)
        }
        historySuggest.tapSuggest    = tapSuggest
        dictionarySuggest.tapSuggest = tapSuggest
        
        // set keyboard notifications.
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        historySuggest.showSuggests(masterVC.history, search: searchText)
        
        // Spell check
        let spells = textChecker.guessesForWordRange(NSMakeRange(0, searchText.characters.count), inString: searchText, language: "en-US")
        dictionarySuggest.showSuggests(spells as? [String])
        
        if (historySuggest.suggests.count > 0 || dictionarySuggest.suggests.count > 0) {
            suggestView.hidden = false
        } else {
            suggestView.hidden = true
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        suggestView.hidden = true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let search = searchBar.text else {
            return
        }
        
        suggestView.hidden = true
        searchBar.text = nil
        
        libContainerVC.search(search)
        
        masterVC.insertNewObject(search)
    }
    
    // MARK: Keyboard Notification
    
    func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo, let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        libContainerViewBottom.constant = keyboard.CGRectValue().height
        
        UIView.animateWithDuration(0.8) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        libContainerViewBottom.constant = 0
        
        UIView.animateWithDuration(0.8) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
