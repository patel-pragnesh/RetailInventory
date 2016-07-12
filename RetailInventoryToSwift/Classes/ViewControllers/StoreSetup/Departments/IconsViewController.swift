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
    
    weak var delegate: IconsViewControllerDelegate?
    
    let iconData = IconData()
    
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
        iconData.source = sender.selectedSegmentIndex
        collectionView.reloadData()
    }
}

extension IconsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconData.сount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IconsCell.cellIdentifier, forIndexPath: indexPath) as! IconsCell
        cell.title = iconData.itemForIndex(indexPath.row)
        return cell
    }
}

extension IconsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.iconsViewControllerResponse(iconData.itemForIndex(indexPath.row))
        navigationController?.popViewControllerAnimated(true)
    }
}