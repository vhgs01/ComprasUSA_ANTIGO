//
//  UIViewController+CoreData.swift
//  MoviesLib
//
//  Created by Fellipe Soares Oliveira on 19/04/2018.
//  Copyright © 2018 Fellipe Soares Oliveira. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
