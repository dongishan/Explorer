//
//  MapTabBarController.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 07/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import UIKit

class MapTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showActionSheet(sender: UIBarButtonItem){
        let mapVC = self.viewControllers?[0] as! MapViewController
        mapVC.showOptionsActionSheet()
    }
    
}
