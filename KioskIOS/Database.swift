//
//  Database.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit
import CoreData

class Database {
    
    struct Customer {
        let id: String
        let name: String
        let email: String
    }
    
    static func saveCustomer(name: String, id: String, email: String) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Customer",
                                                        inManagedObjectContext:managedContext)
        
        let customer = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        customer.setValue(name, forKey: "name")
        customer.setValue(id, forKey: "id")
        customer.setValue(email, forKey: "email")
        
        do {
            try managedContext.save()
            
            print("saveCustomer \(name)")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func loadCustomers() -> [Customer] {
        
        var customers:[Customer] = []
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Customer")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let customersObjects = results as! [NSManagedObject]
            
            for customerObject in customersObjects {
                let name = customerObject.valueForKey("name") as? String
                let id = customerObject.valueForKey("id") as? String
                let email = customerObject.valueForKey("email") as? String
                
                customers.append(Customer(id:id!, name:name!, email:email!))
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return customers
    }
}
