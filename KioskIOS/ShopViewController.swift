//
//  ShopViewController.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit
import AVFoundation

protocol CustomerSelectedDelegate: class {
    func customerSelected(customer: Database.Customer)
}

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var currentCustomer : Database.Customer?
    
    var customers: [Database.Customer] = []
    var articles: [Database.Article] = []
    
    var backButton:UIBarButtonItem?
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        initNavigation();
        //runCameraSession()
        
        loadData()
    }
    
    func initNavigation() {
        let addButton = UIBarButtonItem(title: nil,
                                        style: .Plain,
                                        target: self,
                                        action: #selector(addButtonPressed(_:)))
        let addImage = UIImage(named: "ic_add") as UIImage?
        addButton.image = addImage
        
        
        backButton = UIBarButtonItem(title: nil,
                                     style: .Plain,
                                     target: self,
                                     action: #selector(backButtonPressed(_:)))
        let backImage = UIImage(named: "ic_back") as UIImage?
        backButton!.image = backImage
        
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = nil;
        
    }
    
    func addButtonPressed(sender: UIBarButtonItem) {
        if (currentCustomer == nil) {
            createCustomer("")
        } else {
            createArticle("")
        }
    }
    
    func backButtonPressed(sender: UIBarButtonItem) {
        currentCustomer = nil
        self.navigationItem.leftBarButtonItem = nil
        self.title = "Shop"
        loadData()
    }
    
    func loadData() {
        customers.removeAll();
        customers.appendContentsOf(Database.loadCustomers())
        
        articles.removeAll();
        articles.appendContentsOf(Database.loadArticles())
        
        table.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        if (currentCustomer != nil) {
            return articles.count
        } else {
            return customers.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = table.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if (currentCustomer != nil) {
            let article = articles[indexPath.row]
            cell.detailTextLabel?.text = String(format: "%.2f", Float(article.price) / 100.0) + "€"
            cell.textLabel?.text = article.name
        } else {
            let customer = customers[indexPath.row]
            cell.textLabel?.text = customer.name
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (currentCustomer != nil) {
            let article = articles[indexPath.row]
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            buyArticle(currentCustomer!, article: article)
            currentCustomer = nil
            self.title = "Shop"
            self.navigationItem.leftBarButtonItem = nil

        } else {
            let customer = customers[indexPath.row]
            currentCustomer = customer;
            self.title = customer.name
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        table.reloadData()
    }
    
    func createCustomer(code: String) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Create Customer", message: nil, preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (idField) -> Void in
            idField.placeholder = "ID"
            idField.text = code
        })
        alert.addTextFieldWithConfigurationHandler({ (nameField) -> Void in
            nameField.placeholder = "Name"
            nameField.text = ""
        })
        alert.addTextFieldWithConfigurationHandler({ (emailField) -> Void in
            emailField.placeholder = "E-Mail"
            emailField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let idField = alert.textFields![0] as UITextField
            let nameField = alert.textFields![1] as UITextField
            let emailField = alert.textFields![2] as UITextField
            
            Database.saveCustomer(nameField.text!, id: idField.text!, email: emailField.text!)
            self.loadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createArticle(code: String) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Create Article", message: nil, preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (idField) -> Void in
            idField.placeholder = "ID"
            idField.text = code
        })
        alert.addTextFieldWithConfigurationHandler({ (nameField) -> Void in
            nameField.placeholder = "Name"
            nameField.text = ""
        })
        alert.addTextFieldWithConfigurationHandler({ (priceField) -> Void in
            priceField.placeholder = "Price in cent"
            priceField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let idField = alert.textFields![0] as UITextField
            let nameField = alert.textFields![1] as UITextField
            let priceField = alert.textFields![2] as UITextField
            
            Database.saveArticle(nameField.text!, id: idField.text!, price: Int(priceField.text!)!)
            self.loadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func buyArticle(customer: Database.Customer, article: Database.Article){
        print("buy article")
        
        Database.savePurchase(customer, article: article)
        
    }}

