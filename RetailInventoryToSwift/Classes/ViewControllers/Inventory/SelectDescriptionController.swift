//
//  SelectDescriptionController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/28/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol SelectDescription: class {
    func selectDescription(description: String)
}

class SelectDescriptionController: BaseViewController {
    
    var descriptions: [String]!
    weak var delegate: SelectDescription?
    private var keyboardFrame: CGRect!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var newDescriptionLabel: UILabel!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitles()
        setupTableView()
        subscribeKeyboardNotification()
    }
    
    // MARK: - Private
    
    private func configTitles() {
        self.navigationItem.title = "selectDesc.title".localized
        newDescriptionLabel.text = "selectDesc.label".localized
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    // MARK: - Override
    
    override func keyboardWillShow(notification: NSNotification) {
        keyboardFrame = keyboardFrameInfo(notification)
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        tableView.contentInset = contentInsets
        
        animateScrollTableView(true)
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = contentInsets
    }
    
    // MARK: - Animation scroll tableView
    
    func animateScrollTableView(animated: Bool) {
        tableView.scrollRectToVisible((tableView.tableFooterView?.frame)!, animated: animated)
    }
}

// MARK: - UITableViewDataSource

extension SelectDescriptionController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SelectDescriptionCell.cellIdentifier, forIndexPath: indexPath) as! SelectDescriptionCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        cell.descriptionText = descriptions[indexPath.row]
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SelectDescriptionController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.selectDescription(descriptions[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: - TextViewDelegate

extension SelectDescriptionController: UITextViewDelegate {
    
    func textViewDidEndEditing(textView: UITextView) {
        delegate?.selectDescription(textView.text)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.navigationController?.popViewControllerAnimated(true)
        }
        return true
    }    
}