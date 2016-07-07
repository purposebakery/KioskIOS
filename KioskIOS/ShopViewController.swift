//
//  ShopViewController.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit

protocol CustomerSelectedDelegate: class {
    func customerSelected(customer: Database.Customer)
}

class ShopViewController: UIViewController, CustomerSelectedDelegate {
    
    
    @IBOutlet weak var customerContainer: UIView!
    @IBOutlet weak var articleContainer: UIView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerContainer.hidden = true
        articleContainer.hidden = false
        
        //self.navigationItem.title = "Shop"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("prepareForSegue")
        if segue.identifier == "initDelegatesCustomer" {
            print("prepareForSegue: initDelegatesCustomer")
            let customerViewController = segue.destinationViewController as! ShopCustomerViewController
            customerViewController.delegate = self
        }
    }
    
    func toggleViewVisibility() {
        customerContainer.hidden = !customerContainer.hidden
        
        articleContainer.hidden = !articleContainer.hidden
    }
    
    func customerSelected(customer: Database.Customer) {
    
        print("did select: \(customer.name)")
        
        toggleViewVisibility()
    }
}

