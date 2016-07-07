//
//  ScanController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/27/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class ScanController: BaseViewController {
    
    weak var delegate: ScanNewBarCodeDelegate?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scanNewButton: UIButton!
    @IBOutlet weak var rescanButton: UIButton!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTitles()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Private
    
    private func configTitles() {
        cancelButton.setTitle("scan.cancel".localized, forState: .Normal)
        scanNewButton.setTitle("scan.scanNew".localized, forState: .Normal)
        rescanButton.setTitle("scan.rescan".localized, forState: .Normal)
    }
    
    private func randomAlphaNumericString(length: Int) -> String {
        
        let barcodes = ["9501101530003", "5014016150821", "9771234567003", "671860013624", "036000291452", "5010029020519", "9788679912077", "6000980911046"]
        let randomNum = Int(arc4random_uniform(UInt32(barcodes.count)))
        return barcodes[randomNum]
    }
    
    private func closeController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func scanNewButtonTouch(sender: AnyObject) {
        let newBarcode = randomAlphaNumericString(13)
        scanNew(newBarcode)
        closeController()
    }
    
    @IBAction func rescanButtonTouch(sender: AnyObject) {
        let newBarcode = randomAlphaNumericString(13)
        editExisting(newBarcode)
        closeController()
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        closeController()
    }   
}

// MARK: - ScanNewBarCodeDelegate

extension ScanController: ScanNewBarCodeDelegate {
    
    func scanNew(barcode: String) {
        delegate?.scanNew(barcode)
    }
    
    func editExisting(barcode: String) {
        delegate?.editExisting(barcode)
    }
}
