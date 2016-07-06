//
//  ShopCustomerController.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit

class ShopCustomerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var customerTable: UITableView!
    
    struct Customer {
        let id: String
        let name: String
    }
    
    let customers = [
        Customer(id: "456789765", name: "Johannes"),
        Customer(id: "671923712093", name: "Oliver"),
        Customer(id: "0987623329", name: "Thomas")
        ]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerTable.dataSource = self
        customerTable.delegate = self
        customerTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        
        
        /*
        var count:Int?
        
        if tableView == self.tableView {
            count = sampleData.count
        }
        
        if tableView == self.tableView1 {
            count =  sampleData1.count
        }
        
        return count!*/
        return customers.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*
        var cell:UITableViewCell?
        
        if tableView == self.tableView {
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            let previewDetail = sampleData[indexPath.row]
            cell!.textLabel!.text = previewDetail.title
            
        }
        
        if tableView == self.tableView1 {
            cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            let previewDetail = sampleData1[indexPath.row]
            cell!.textLabel!.text = previewDetail.title
            
        }
        
        
        return cell!*/
        
        let cell:UITableViewCell = customerTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let customer = customers[indexPath.row]
        cell.textLabel?.text = customer.name
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select:      \(indexPath.row)  ")
    }
}

