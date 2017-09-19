//
//  ExTabbarViewController.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 04/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import UIKit

class ExTabbarViewController: UITabBarController, UITabBarControllerDelegate {

    let SCAN_VC_INDEX = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if selectedIndex != SCAN_VC_INDEX && viewController.isKind(of: ScanViewController.classForCoder()){
            let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
            let arMarkerAction = UIAlertAction(title: "Scan an AR Marker", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            let barcodeAction = UIAlertAction(title: "Scan a Barcode or QR Code", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.selectedIndex = 2
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            
            optionMenu.addAction(arMarkerAction)
            optionMenu.addAction(barcodeAction)
            optionMenu.addAction(cancelAction)
            
            present(optionMenu, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
}
