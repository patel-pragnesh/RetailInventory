//
//  IconsViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol IconsViewControllerDelegate
{
    func iconsViewControllerResponse(icon: Character)
}

class IconsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var delegateIconViewController: IconsViewControllerDelegate?
    
    var arrayIcons = [Character]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for char in 61440 ... 61568 {
            arrayIcons.append(Character(UnicodeScalar(char)))
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayIcons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IconsCell.cellIdentifier, forIndexPath: indexPath) as! IconsCell
        cell.title = arrayIcons[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegateIconViewController?.iconsViewControllerResponse(arrayIcons[indexPath.row])
        navigationController?.popViewControllerAnimated(true)
    }
}
