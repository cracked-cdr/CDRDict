//
//  CustomLibraryViewController.swift
//  CDRDict
//
//  Copyright © 2015年 cracked-cdr. All rights reserved.
//

import UIKit

class CustomLibraryViewController: UIReferenceLibraryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove NavigationBar and Toolbar.
        removeView(self.view, targetClass: UINavigationBar.self)
        removeView(self.view, targetClass: UIToolbar.self)
    }
    
    /// Get HTML in dictionary.
    func html() ->String? {
        guard let webView = searchWebView(view) else {
            return nil
        }
        
        let html = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.textContent")
        
        return html
    }

    /// Search and remove NavigationItems.
    private func removeNavigationItems(vc: UIViewController) {
        for child in vc.childViewControllers {
            let naviItem = child.navigationItem
            naviItem.hidesBackButton = true
            if (naviItem.leftBarButtonItems != nil || naviItem.rightBarButtonItems != nil) {
                child.navigationItem.leftBarButtonItems = nil
                child.navigationItem.rightBarButtonItems = nil
            }
            
            removeNavigationItems(child)
        }
    }
    
    /// Search and remove instance.
    private func removeView(root: UIView, targetClass: AnyClass) {
        for sub in root.subviews {
            if (sub.isKindOfClass(targetClass)) {
                sub.removeFromSuperview()
                return
            }
            removeView(sub, targetClass: targetClass)
        }
    }
    
    /// Get UIWebView in dictionary.
    private func searchWebView(v: UIView) -> UIWebView? {
        for sub in v.subviews {
            if (sub is UIWebView) {
                return sub as? UIWebView
            }
            
            if let wb = searchWebView(sub) {
                return wb
            }
        }
        
        return nil
    }
}
