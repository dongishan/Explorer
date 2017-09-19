//
//  Extensions.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 02/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import UIKit

extension UIViewController{
    
    @IBAction func dismissModally() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension UIColor{
    
    class func mapOrange()->UIColor{
        return UIColor(red: 0.92, green: 0.35, blue: 0.21, alpha: 1.00)
    }
    
    class func exBackground()->UIColor{
        return UIColor(red: 0.05, green: 0.17, blue: 0.26, alpha: 1.00)
    }
    
    class func exGreen()->UIColor{
        return UIColor(red: 0.47, green: 0.78, blue: 0.31, alpha: 1.00)
    }
    
    class func exYellow()->UIColor{
        return UIColor(red: 0.89, green: 0.85, blue: 0.22, alpha: 1.00)
    }
}

