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
    @IBOutlet var collectionSelectSourceButtons: [UIButton]!
    
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitles()
    }
    
    // MARK: - Private
    
    private func configTitles() {
        self.navigationItem.title = "icon.title".localized
        for button in collectionSelectSourceButtons {
            switch TypeIcons(rawValue: button.tag)! {
            case .hospitality:
                button.setTitle("icon.hospitality".localized, forState: .Normal)
                selectedStateFor(button)
            case .retail:
                button.setTitle("icon.retail".localized, forState: .Normal)
            }
        }
    }
    
    private func configButtonsState(selectedButtonTag: Int) {
        for button in collectionSelectSourceButtons {
            if button.tag == selectedButtonTag {
                button.selected = true
            } else {
                button.selected = false
            }
        }
        
    }
    
    private func selectedStateFor(button: UIButton) {
        button.selected = true
    }
    
    // MARK: - Action
    
    @IBAction func selectSourceButtonTouched(sender: UIButton) {
        configButtonsState(sender.tag)
        iconData.typeIcons = TypeIcons(rawValue: sender.tag)!
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