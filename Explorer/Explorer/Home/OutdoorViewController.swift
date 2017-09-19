//
//  OutdoorViewController.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 02/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import UIKit

class OutdoorViewController: UIViewController{
    
    // MARK: - Properties
    
    let cardCellId = "CardCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    let itemsPerRow: CGFloat = 3
    let images = [#imageLiteral(resourceName: "icon_6"), #imageLiteral(resourceName: "icon_7"), #imageLiteral(resourceName: "icon_8"), #imageLiteral(resourceName: "icon_9"), #imageLiteral(resourceName: "icon_10"), #imageLiteral(resourceName: "icon_11"), #imageLiteral(resourceName: "icon_8"), #imageLiteral(resourceName: "icon_7"), #imageLiteral(resourceName: "icon_10"), #imageLiteral(resourceName: "icon_6"), #imageLiteral(resourceName: "icon_8"), #imageLiteral(resourceName: "icon_9")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UICollectionViewDataSource

extension OutdoorViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardCellId, for: indexPath) as!LevelCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        if indexPath.row == 0{
            cell.letterLabel.text = "M"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OutdoorViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
