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
    
    struct Article {
        let id: String
        let name: String
        let price: Int
    }
    
    struct Purchase {
        let timestamp: NSDate
        let value: Int
        let customerName: String
        let customerId: String
        let articleName: String
        let articleId: String
    }
    
    static func savePurchase(customer: Customer, article: Article) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Purchase",
                                                        inManagedObjectContext:managedContext)
        
        let purchase = NSManagedObject(entity: entity!,
                                       insertIntoManagedObjectContext: managedContext)
        
        let date = NSDate()
        
        purchase.setValue(date, forKey:"timestamp")
        purchase.setValue(article.price, forKey: "value")
        purchase.setValue(customer.name, forKey: "customerName")
        purchase.setValue(customer.id, forKey: "customerId")
        purchase.setValue(article.name, forKey: "articleName")
        purchase.setValue(article.id, forKey: "articleId")
        
        do {
            try managedContext.save()
            
            //print("saveCustomer \(name)")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    static func clearPurchases() {
        let fetchRequest = NSFetchRequest(entityName: "Purchase")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            try managedContext.executeRequest(deleteRequest)
        } catch let error as NSError {
            print(error.description)
            // TODO: handle the error
        }
    
    }
    
    static func loadPurchases() -> [Purchase] {
        
        var purchases:[Purchase] = []
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Purchase")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let purchaseObjects = results as! [NSManagedObject]
            
            for purchaseObject in purchaseObjects {
                let timestamp = purchaseObject.valueForKey("timestamp") as? NSDate
                let value = purchaseObject.valueForKey("value") as? Int
                let customerName = purchaseObject.valueForKey("customerName") as? String
                let customerId = purchaseObject.valueForKey("customerId") as? String
                let articleName = purchaseObject.valueForKey("articleName") as? String
                let articleId = purchaseObject.valueForKey("articleId") as? String
                purchases.append(Purchase(timestamp:timestamp!, value:value!, customerName:customerName!, customerId:customerId!, articleName:articleName!, articleId:articleId!))
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return purchases
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
    
    
    static func saveArticle(name: String, id: String, price: Int) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Article",
                                                        inManagedObjectContext:managedContext)
        
        let article = NSManagedObject(entity: entity!,
                                       insertIntoManagedObjectContext: managedContext)
        
        article.setValue(name, forKey: "name")
        article.setValue(id, forKey: "id")
        article.setValue(price, forKey: "price")
        
        do {
            try managedContext.save()
            
            print("saveArticle \(name)")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func loadArticles() -> [Article] {
        
        var articles:[Article] = []
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Article")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let articleObjects = results as! [NSManagedObject]
            
            for articleObject in articleObjects {
                let name = articleObject.valueForKey("name") as? String
                let id = articleObject.valueForKey("id") as? String
                let price = articleObject.valueForKey("price") as? Int
                
                articles.append(Article(id:id!, name:name!, price:price!))
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return articles
    }
}