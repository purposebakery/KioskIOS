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

class PaymentViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBAction func buttonpressed(sender: UIButton) {
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
        
        mailComposeViewController.setToRecipients(["oliver.metz@bertesmann.de"])
        mailComposeViewController.setSubject("Kiosk Peaches Payments")
        mailComposeViewController.setMessageBody(message + "\n\nCustomers:\n" + customers + "\n\nPurchases:\n" + purchaseSummary, isHTML: false)

        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func showSendMailErrorAlert() {
        //let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        //sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func clearPressed(sender: UIButton) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.title = "Payment"
    }
}
