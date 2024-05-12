//
//  UIViewExtension.swift
//  CoreData and API
//
//  Created by DB-MBP-012 on 12/05/24.
//

import Foundation
import UIKit

extension UIView {
    func showLoader() {
        let loaderView = UIView(frame: bounds)
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loaderView.tag = 999 // Use a unique tag to identify the loader view
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loaderView.center
        activityIndicator.startAnimating()
        
        loaderView.addSubview(activityIndicator)
        addSubview(loaderView)
    }
    
    func hideLoader() {
        if let loaderView = viewWithTag(999) {
            loaderView.removeFromSuperview()
        }
    }
}
