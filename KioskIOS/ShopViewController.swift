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
    
    //@IBOutlet weak var customerContainer: UIView!
    //@IBOutlet weak var articleContainer: UIView!
    
    // Camera stuff
    @IBOutlet weak var camera: UIImageView!
    
    var captureSession: AVCaptureSession!
    var captureDevice : AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // Speech stuff
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var currentCustomer : Database.Customer?
    
    var customers: [Database.Customer] = []
    var articles: [Database.Article] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        //customerContainer.hidden = true
        //articleContainer.hidden = false
        
        //initCamera()
        runCameraSession()
        
        //self.navigationItem.title = "Shop"
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
            cell.textLabel?.text = "" + String(article.price) + " cent - " + article.name
        } else {
            let customer = customers[indexPath.row]
            cell.textLabel?.text = customer.name
        }
        
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (currentCustomer != nil) {
            let article = articles[indexPath.row]
            buyArticle(currentCustomer!, article: article)
            currentCustomer = nil
        } else {
            let customer = customers[indexPath.row]
            currentCustomer = customer;
        }
        
        table.reloadData()
    }

    
    /*
    func initCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Front) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        runCameraSession()
                    }
                }
            }
        }
        
    }*/
    
    func runCameraSession() {
        
        do {
            /*
            // Setup preview preview
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            let bounds = self.camera.bounds
            previewLayer?.bounds = bounds
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer?.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            self.camera.layer.addSublayer(previewLayer!)
            
            
            // Setup Barcode scanning
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeQRCode]
            }
            
            captureSession.startRunning()*/
            
            
            
            
            
            
            captureSession = AVCaptureSession()
            
            let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                failed();
                return;
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode]
            } else {
                failed()
                return
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
            /*previewLayer.frame = view.layer.bounds;
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            view.layer.addSublayer(previewLayer);*/
            
            let bounds = self.camera.bounds
            previewLayer.bounds = bounds
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            self.camera.layer.addSublayer(previewLayer!)
            
            captureSession.startRunning();
        } catch {
            
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    /*
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.running == true) {
            captureSession.stopRunning();
        }
    }*/
    /*
    override func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        */
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            foundCode(readableObject.stringValue);
        }
    }
    
    func foundCode(code: String) {
        print("Code scanned: " + code)
        if code.characters.count > 4 {
            foundCustomer(code)
        } else {
            foundArticle(code)
        }
    }
    
    func createCustomer(code: String) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Create Customer", message: "with id: " + code, preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
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
            let nameField = alert.textFields![0] as UITextField
            let emailField = alert.textFields![1] as UITextField
            
            Database.saveCustomer(nameField.text!, id: code, email: emailField.text!)
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createArticle(code: String) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Create Article", message: "with id: " + code, preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
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
            let nameField = alert.textFields![0] as UITextField
            let priceField = alert.textFields![1] as UITextField
            
            Database.saveArticle(nameField.text!, id: code, price: Int(priceField.text!)!)
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    func foundCustomer(code: String) {
        
        if currentCustomer != nil {
            print("customer already set")
            return
        }
        
        for customer in Database.loadCustomers() {
            if (customer.id == code) {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                utterText(customer.name)
                print("found customer: " + customer.name + " " + customer.id)
                currentCustomer = customer;
                return
            }
        }
        
        // if customer not found
        createCustomer(code)
    }
    
    func foundArticle(code: String) {
        for article in Database.loadArticles() {
            if (article.id == code) {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                utterText("one " + article.name)
                print("found article: " + article.name + " " + article.id)
                buyArticle(currentCustomer!, article: article)
                currentCustomer = nil
                //toggleViewVisibility()
                return
            }
        }
        
        
        // if article not found
        //createArticle(code)
    }
    
    func utterText(text : String) {
        print("utter text: " + text)
        myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.3
        synth.speakUtterance(myUtterance)
    }
    
    func buyArticle(customer: Database.Customer, article: Database.Article){
        print("buy article")
        
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("prepareForSegue")
        if segue.identifier == "initDelegatesCustomer" {
            print("prepareForSegue: initDelegatesCustomer")
            let customerViewController = segue.destinationViewController as! ShopCustomerViewController
            customerViewController.delegate = self
        }
    }*/
    
    /*
    func toggleViewVisibility() {
        print("toggleViewVisibility")
        customerContainer.hidden = !customerContainer.hidden
        
        articleContainer.hidden = !articleContainer.hidden
    }*/
    
    /*
    func customerSelected(customer: Database.Customer) {
    
        print("did select: \(customer.name)")
        
        toggleViewVisibility()
    }*/
}

