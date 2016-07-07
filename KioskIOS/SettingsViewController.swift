//
//  SettingsViewController.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var itemTableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationButton()

        
        //self.navigationItem.title = "Settings"
    }
    
    func initNavigationButton() {
        let optionButton = UIBarButtonItem()
        optionButton.title = "Add"
        //optionButton.action = something (put your action here)
        self.navigationItem.rightBarButtonItem = optionButton
    }
}
