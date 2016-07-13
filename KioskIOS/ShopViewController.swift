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

class ShopViewController: UIViewController, CustomerSelectedDelegate {
    
    
    @IBOutlet weak var customerContainer: UIView!
    @IBOutlet weak var articleContainer: UIView!
    
    @IBOutlet weak var camera: UIImageView!
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerContainer.hidden = true
        articleContainer.hidden = false
        
        initCamera()
        
        //self.navigationItem.title = "Shop"
    }
    
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
        
    }
    
    func runCameraSession() {
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            let bounds = self.camera.bounds
            previewLayer?.bounds = bounds
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer?.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            self.camera.layer.addSublayer(previewLayer!)
            //previewLayer?.frame = self.view.layer.frame
            //previewLayer?.frame = self.camera.layer.frame
            captureSession.startRunning()
        } catch {
            
        }
        
        
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

