//
//  ViewController+CoreData.swift
//  myGames
//
//  Created by Anne Victoria Batista Auzier on 20/12/23.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
 
}
