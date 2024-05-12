//
//  Constants.swift
//  CoreData and API
//
//  Created by DB-MBP-012 on 11/05/24.
//

import Foundation
import UIKit

typealias K = Constants

struct Constants {
    
    struct XIBCell {
        
        static let userDetailsInfoCell = "UserDetailsInfoCell"
    }
    
    
    //MARK: - Storyboard
      struct Storyboard {
          static let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          
      }
    
    //MARK: - ViewControllers Screen
    struct Screen {
        //Authentication
        static let UserDetailsVC = "UserDetailsViewController"
        static let LocationVC = "LocationViewController"
    }
    
    struct endPoints {
        
        static let urlString = "https://crudcrud.com/api/aa642d62a1344b179433ebe125baf575/unicorns"
    }
}
