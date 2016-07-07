//
//  IconsViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol IconsViewControllerDelegate: class {
    func iconsViewControllerResponse(icon: Character)
}

class IconsViewController: BaseViewController {
    
    weak var delegateIconViewController: IconsViewControllerDelegate?
    
    let iconData = IconData()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconData.count
    }
}

extension IconsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IconsCell.cellIdentifier, forIndexPath: indexPath) as! IconsCell
        cell.title = iconData.itemForIndex(indexPath.row)
        return cell
    }
}

extension IconsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegateIconViewController?.iconsViewControllerResponse(iconData.itemForIndex(indexPath.row)!)
        navigationController?.popViewControllerAnimated(true)
    }
}