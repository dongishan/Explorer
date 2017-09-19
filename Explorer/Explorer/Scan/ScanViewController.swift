//
//  ScanViewController.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 02/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var flashButton: UIButton!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    let SIMULATE_CAMERA_UNAVAILABLE_DEVICE_ERROR = false
    let SIMULATE_CAMERA_UNAVAILABLE_LOW_BATTERY = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SIMULATE_CAMERA_UNAVAILABLE_DEVICE_ERROR{
            let alertVC = PMAlertController(title: "Camera Unavailable", description: "EXPLORER cannot open your device camera. Please enter the serial number of the Barcode, QR Marker or AR Marker below. This serial number is available right below the marker image.", image: nil, style: .alert)
            alertVC.addAction(PMAlertAction(title: "Submit", style: .default,  action: nil))
            alertVC.addTextField({ (textField) in
                textField?.placeholder = "Serial number"
            })
            present(alertVC, animated: true, completion: nil)
            return
        }
        
        if SIMULATE_CAMERA_UNAVAILABLE_LOW_BATTERY{
            let alertVC = PMAlertController(title: "Low Battery", description: "Your device is running low on battery. Openning the camera will drain it further. Would you like to enter the serial number manually instead?", image: nil, style: .alert)
            alertVC.addTextField({ (textField) in
                textField?.placeholder = "Serial number"
            })
            alertVC.addAction(PMAlertAction(title: "Submit", style: .default,  action: nil))
            alertVC.addAction(PMAlertAction(title: "No, open the camera", style: .cancel,  action: nil))
            present(alertVC, animated: true, completion: nil)
            return
        }

        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: flashButton)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.exGreen().cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleFlash(sender: UIButton) {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo){
            if (device.hasTorch) {
                do {
                    try device.lockForConfiguration()
                    if (device.torchMode == AVCaptureTorchMode.on) {
                        device.torchMode = AVCaptureTorchMode.off
                        self.flashButton.setImage(#imageLiteral(resourceName: "flash_off"), for: .normal)
                    } else {
                        do {
                            try
                                device.setTorchModeOnWithLevel(1.0)
                            self.flashButton.setImage(#imageLiteral(resourceName: "flash_on"), for: .normal)
                            
                        } catch {
                            print(error)
                        }
                    }
                    device.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedBarCodes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                let value = metadataObj.stringValue
                messageLabel.text = value
                
                if value == "0002"{
                    //Question
                    let alertVC = PMAlertController(title: "Qui-Gon Jam Riddle", description: "Where does Qui-Gon keep his jam?", image: #imageLiteral(resourceName: "qui_gon"), style: .alert)
                    alertVC.addTextField({ (textField) in
                        textField?.placeholder = "Enter you answer here"
                    })
                    alertVC.addAction(PMAlertAction(title: "Submit", style: .default, action: { () -> Void in
                     /*   let answerAlertVC = PMAlertController(title: "Correct!", description: "Qui-Gon keep his jam in \"Jar Jar\"\n\nYou have successfully unlocked a new character in the Amazon voucher code", image: nil, style: .alert)
                        answerAlertVC.addAction(PMAlertAction(title: "Ok", style: .default, action: nil))
                        self.present(answerAlertVC, animated: true, completion: nil)*/
                    }))
                    //present(alertVC, animated: true, completion: nil)
                  
                    //Answer
                    let answerAlertVC = PMAlertController(title: "Correct!", description: "Qui-Gon keep his jam in \"Jar Jar\"\n\nYou have successfully unlocked a new character in the Amazon voucher code", image: nil, style: .alert)
                    answerAlertVC.addAction(PMAlertAction(title: "Ok", style: .default, action: nil))
                    present(answerAlertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        
        layer.videoOrientation = orientation
        
        videoPreviewLayer?.frame = self.view.bounds
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.videoPreviewLayer?.connection  {
            
            let currentDevice: UIDevice = UIDevice.current
            
            let orientation: UIDeviceOrientation = currentDevice.orientation
            
            let previewLayerConnection : AVCaptureConnection = connection
            
            if previewLayerConnection.isVideoOrientationSupported {
                
                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                    
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                
                    break
                    
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                
                    break
                    
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                
                    break
                    
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                }
            }
        }
    }
}
