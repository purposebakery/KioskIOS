//
//  PaymentViewController.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class PaymentViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let PROCESS_PAYMENT : Int = 1
    let PROCESS_CLEAR : Int = 2
    let PROCESS_SUMMARY : Int = 3
    
    let ADMIN_PIN : String = "Android"
    
    var currentSummary: [String:PurchasesViewController.SummaryItem] = [:]
    var currentCustomers: [Database.Customer] = []
    
    @IBAction func summaryPressed(sender: UIButton) {
        paymentSummary()
    }
    
    @IBAction func buttonpressed(sender: UIButton) {
        paymentCustomersAll()
    }
    
    
    func paymentSummary() {
        print("trigger")
        
        var summary : [String:PurchasesViewController.SummaryItem] = [:]
        
        var purchaseSummary = "";
        
        for purchase in Database.loadPurchases() {
            let timestamp = NSDateFormatter.localizedStringFromDate(purchase.timestamp, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
            
            purchaseSummary = purchaseSummary + timestamp + ";" + purchase.articleId + ";" + purchase.articleName + ";";
            purchaseSummary = purchaseSummary + purchase.customerId + ";" + purchase.customerName + ";"
            purchaseSummary = purchaseSummary + String(purchase.value) + "\n"
            
            var customerExists:Bool = false;
            for (id , summaryItem) in summary {
                if (id == purchase.customerId) {
                    customerExists = true;
                    summary[id] = PurchasesViewController.SummaryItem(customerName:purchase.customerName, customerId:purchase.customerId, value:summaryItem.value + purchase.value)
                }
            }
            if (!customerExists) {
                summary[purchase.customerId] = PurchasesViewController.SummaryItem(customerName:purchase.customerName, customerId:purchase.customerId, value:purchase.value)            }
        }
                
        var message = "";
        for (key , summaryItem) in summary {
            message = message + summaryItem.customerName + ": " + String(format: "%.2f", Float(summaryItem.value) / 100.0) + "€" + "\n"
        }
        
        print("message: " + message)
        
        
        var customers = ""
        for customer in Database.loadCustomers() {
            customers = customers + customer.name + ": " + customer.email + "\n"
        }
        
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposeViewController.setToRecipients(["kioskpeaches@gmail.com", "ometz@posteo.de"])
        mailComposeViewController.setSubject("Kiosk Peaches Payment")
        mailComposeViewController.setMessageBody(message + "\n\nCustomers:\n" + customers + "\n\nPurchases:\n" + purchaseSummary, isHTML: false)
        
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: false, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func paymentCustomersAll() {
        print("trigger")
        
        currentSummary.removeAll()
        
        for purchase in Database.loadPurchases() {
            var customerExists:Bool = false;
            for (id , summaryItem) in currentSummary {
                if (id == purchase.customerId) {
                    customerExists = true;
                    currentSummary[id] = PurchasesViewController.SummaryItem(customerName:purchase.customerName, customerId:purchase.customerId, value:summaryItem.value + purchase.value)
                }
            }
            if (!customerExists) {
                currentSummary[purchase.customerId] = PurchasesViewController.SummaryItem(customerName:purchase.customerName, customerId:purchase.customerId, value:purchase.value)            }
        }
        
        var message = "";
        for (key , summaryItem) in currentSummary {
            message = message + summaryItem.customerName + ": " + String(format: "%.2f", Float(summaryItem.value) / 100.0) + "€" + "\n"
        }
        
        print("message: " + message)
        
        currentCustomers = Database.loadCustomers()
        
        processPlayments()
    }
    
    func processPlayments() {
        print("processing payments: " + String(currentCustomers.count))
        
        if (currentCustomers.isEmpty) {
            return
        } else {
            let customer = currentCustomers[0]
            
            let email = customer.email
            let name = customer.name
            let summaryItem = currentSummary[customer.id]
            
            if (summaryItem != nil) {
                let value = String(format: "%.2f", Float(summaryItem!.value) / 100.0)
                
                paymentCustomersSingle(email, name: name, value: value)
            }
            
            currentCustomers.removeAtIndex(0)
        }
    }
    
    func paymentCustomersSingle(email: String, name: String, value: String) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposeViewController.setToRecipients([email])
        mailComposeViewController.setSubject("Kiosk Peaches Payment - " + name)
        mailComposeViewController.setMessageBody("Hallo " + name + ",\n\nfolgender Betrag muss beglichen werden: " + value + "€.\n\nBitte in Bar bei mir vorbeibringen oder via Paypal abwickeln:\nhttps://www.paypal.me/OliverMetz/" + value, isHTML: false)
        mailComposeViewController.mailComposeDelegate = self
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: false, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        processPlayments()
    }
    
    @IBAction func clearPressed(sender: UIButton) {
        checkPin(PROCESS_CLEAR)
    }
    
    func clear() {
        print("clear")
        
        let alert = UIAlertController(title: "Delete all purchases", message: "Are you sure about this?", preferredStyle: .Alert)
        
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            Database.clearPurchases()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkPin(process: Int) {
        
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Admin Check", message: nil, preferredStyle: .Alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (pinField) -> Void in
                pinField.placeholder = "PIN"
            })
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                let pinField = alert.textFields![0] as UITextField
                
                let pin = pinField.text!
                if (pin == self.ADMIN_PIN) {
                    if (process == self.PROCESS_CLEAR) {
                        self.clear()
                    } else if (process == self.PROCESS_PAYMENT) {
                        self.paymentCustomersAll()
                    } else if (process == self.PROCESS_SUMMARY) {
                        self.paymentSummary()
                    }
                }
            }))
            
            // 4. Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.title = "Payment"
    }
}
