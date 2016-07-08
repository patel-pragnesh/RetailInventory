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

enum TypeIcons {
    case hospitality, retail
}

class IconsViewController: BaseViewController {
    
    weak var delegateIconViewController: IconsViewControllerDelegate?
    
    let iconData = IconData()
    var typeIcons: TypeIcons = .hospitality
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitles()
    }
    
    // MARK: - Private
    
    private func configTitles() {
        self.navigationItem.title = "icon.title".localized
        segmentControlOutlet.setTitle("icon.hospitality".localized, forSegmentAtIndex: 0)
        segmentControlOutlet.setTitle("icon.retail".localized, forSegmentAtIndex: 1)
    }
    
    @IBAction func segmentControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            typeIcons = .hospitality
        case 1:
            typeIcons = .retail
        default: break
        }
        collectionView.reloadData()
    }
}

extension IconsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch typeIcons {
        case .hospitality:
            return iconData.countHospitalityIcons
        case .retail:
            return iconData.countRetailIcons
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IconsCell.cellIdentifier, forIndexPath: indexPath) as! IconsCell
        cell.title = iconData.itemForIndex(indexPath.row, typeIcon: typeIcons)
        return cell
    }
}

extension IconsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegateIconViewController?.iconsViewControllerResponse(iconData.itemForIndex(indexPath.row, typeIcon: typeIcons))
        navigationController?.popViewControllerAnimated(true)
    }
}