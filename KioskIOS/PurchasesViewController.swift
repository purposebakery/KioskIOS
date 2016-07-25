//
//  SettingsViewController.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit

class PurchasesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct SummaryItem {
        var customerName: String = ""
        var customerId: String = ""
        var value: Int = 0;
    }
    
    let SUMMARY : Int = 0
    let HISTORY : Int = 1
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var itemTableView: UITableView!
    
    var state : Int = 0
    
    var purchases : [Database.Purchase] = []
    var summary : [String:SummaryItem] = [:]
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        
        loadData()
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
        
        loadData()
        
        print("changed state to " + String(state))
    }
    
    func loadData() {
        purchases.removeAll();
        purchases.appendContentsOf(Database.loadPurchases())
        
        
        print("purchase count " + String(purchases.count))
        
        summary.removeAll()
        
        for purchase in purchases {
            var customerExists:Bool = false;
            for (id , summaryItem) in summary {
                if (id == purchase.customerId) {
                    customerExists = true;
                    summary[id] = SummaryItem(customerName:purchase.customerName, customerId:purchase.customerId, value:summaryItem.value + purchase.value)
                }
            }
            if (!customerExists) {
                summary[purchase.customerId] = SummaryItem(customerName:purchase.customerName, customerId:purchase.customerId, value:purchase.value)            }
        }
        
        itemTableView.reloadData()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        
        if (state == SUMMARY) {
            return summary.count
        } else {
            return purchases.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = itemTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if (state == SUMMARY) {
            
            let summaryItem = self.summary[Array(self.summary.keys)[indexPath.row]]
            cell.textLabel?.text = summaryItem!.customerName
            cell.detailTextLabel?.text = String(format: "%.2f", Float(summaryItem!.value) / 100.0) + "€"
            
        } else {
            let purchase = self.purchases[indexPath.row]
            let timestamp = NSDateFormatter.localizedStringFromDate(purchase.timestamp, dateStyle: .ShortStyle, timeStyle: .NoStyle)
            cell.textLabel?.text = timestamp + " " + purchase.customerName
            cell.detailTextLabel?.text = purchase.articleName
        }
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
