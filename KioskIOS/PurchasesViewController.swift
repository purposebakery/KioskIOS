//
//  SettingsViewController.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit

class PurchasesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let SUMMARY : Int = 0
    let HISTORY : Int = 1
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var itemTableView: UITableView!
    
    var state : Int = 0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            state = SUMMARY
        case 1:
            state = HISTORY
        default:
            break; 
        }
        
        itemTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        /*
        if (currentCustomer != nil) {
            return articles.count
        } else {
            return customers.count
        }*/
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = itemTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        /*
        if (currentCustomer != nil) {
            let article = articles[indexPath.row]
            cell.textLabel?.text = "" + String(article.price) + " cent - " + article.name
        } else {
            let customer = customers[indexPath.row]
            cell.textLabel?.text = customer.name
        }*/
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        if (currentCustomer != nil) {
            let article = articles[indexPath.row]
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            buyArticle(currentCustomer!, article: article)
            currentCustomer = nil
            self.navigationItem.leftBarButtonItem = nil
            
        } else {
            let customer = customers[indexPath.row]
            currentCustomer = customer;
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        table.reloadData()*/
    }

}
