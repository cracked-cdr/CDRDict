//
//  LibContainerViewController.swift
//  CDRDict
//
//  Copyright © 2015年 cracked-cdr. All rights reserved.
//

import UIKit

class LibContainerViewController: UIViewController {
    
    private var libVC: CustomLibraryViewController! = nil

    /// Search iOS dictionary and show result.
    func search(term: String) {
        // If iOS dictionary displayed, dismiss and remove.
        if (libVC != nil) {
            libVC.view.removeFromSuperview()
            libVC.removeFromParentViewController()
        }
        
        // Create and search.
        libVC = CustomLibraryViewController(term: term)
        addChildViewController(libVC)
        let libView = libVC!.view
        libView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(libVC.view)
        
        // Add Constraints.
        let views = ["libView": libView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[libView(>=0)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[libView(>=0)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}
