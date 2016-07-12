//
//  LogInViewController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/8/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class LogInViewController: BaseViewController {
    
    var defaultButtonConstraint: CGFloat = 0
    var tapRecognizer: UITapGestureRecognizer!
    var countCompletedRequest = 0
    var countRequest = 5
    var isPresentedErrorAlert = false
    
    @IBOutlet weak var merchantIdLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var merchantIDField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var networkActivity: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    
    // MARK: 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        defaultButtonConstraint = self.bottomConstraint.constant
        self.subscribeKeyboardNotification()
        configTitles()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.tapOutSideTextField))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {        
        progressView.hidden = true
    }
    
    deinit {
        self.view.removeGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - set up titles
    
    func configTitles() {
        merchantIdLabel.text = "auth.merchantIDLabel".localized
        passwordLabel.text = "auth.passwordLabel".localized
        logInButton.setTitle("auth.logInButton".localized, forState: .Normal)
    }
    
    // MARK: - buttonAction
    
    @IBAction func onLogInTouch(sender: AnyObject) {
        tapOutSideTextField()
        progressView.hidden = false
        downloadDepartments()
        configProgressLabel()
    }
    
    // MARK: - Tap outside textField
    
    func tapOutSideTextField() {
        self.view.endEditing(true)
    }
    
    // MARK: - keyboardWillShow
    
    override func keyboardWillShow(notification: NSNotification) {
        animateLayoutIfNeeded(durationAnimate, hide: true, notification: notification)
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        animateLayoutIfNeeded(durationAnimate, hide: false, notification: nil)
    }
    
    private func configProgressLabel() {
        progressLabel.text = "downloading " + String(countCompletedRequest) + " in " + String(countRequest) + " components"
    }
    
    // MARK: - Animation With Duration
    
    func animateLayoutIfNeeded(duration: Double, hide: Bool, notification: NSNotification?) {
        if hide {
            self.bottomConstraint.constant = keyboardFrameInfo(notification!).size.height + MyConstant.defaultIdentToKeyboard
            self.logoImageView.hidden = true
            self.logoImageView.alpha = 0
            
            UIView.animateWithDuration(durationAnimate) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.bottomConstraint.constant = defaultButtonConstraint
            self.logoImageView.hidden = false
            self.logoImageView.alpha = 1
          
            UIView.animateWithDuration(durationAnimate){
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Network 
    
    func downloadTaxes() {
        NetworkLoader.downloadTaxes(
            completion: { taxes in
                TaxData().updateTaxes(taxes)
                self.countCompletedRequest += 1
                self.configProgressLabel()
                self.downloadItems()
                
            },
            failure: {(code, message) in
                self.errorAlert(code, message: message)
            }
        )
    }
    
    func downloadItems() {
        NetworkLoader.downloadItems(
            completion: { items in
                InventoryListData.addInventoryFromResponse(items)
                self.countCompletedRequest += 1
                self.configProgressLabel()
                self.downloadSets()
            },
            failure: {(code, message) in
                self.errorAlert(code, message: message)
            }
        )
    }
    
    func downloadDepartments() {
        NetworkLoader.downloadDepartments(
            completion: { departments in
                DepartmentData().updateDepartments(departments)
                self.countCompletedRequest += 1
                self.configProgressLabel()
                self.downloadTaxes()
            },
            failure: {(code, message) in
                self.errorAlert(code, message: message)
            }
        )
    }
    
    func downloadSets() {
        NetworkLoader.downloadSets(
            completion: { sets in
                SetData.addSetsFromResponse(sets)
                self.countCompletedRequest += 1
                self.configProgressLabel()
                self.downloadTags()
            },
            failure: {(code, message) in
                self.errorAlert(code, message: message)
            }
        )
    }
    
    func downloadTags() {
        NetworkLoader.downloadTags(
            completion: { tags in
                TagData.addTagsFromResponse(tags)
                self.countCompletedRequest += 1
                self.configProgressLabel()
                self.progressView.hidden = true
                
                self.performSegueWithIdentifier("showMenu", sender: self)
                self.navigationController?.navigationBarHidden = false
                self.countCompletedRequest = 0
            },
            failure: {(code, message) in
                self.errorAlert(code, message: message)
            }
        )
    }
    
    // MARK: - Alert
    
    func errorAlert(code: UInt, message: String) {
        networkActivity.hidden = true
        if !isPresentedErrorAlert {
            isPresentedErrorAlert = true
            let errorAlert = UIAlertController(title:"\(code)", message: "\(message)", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "storeSetup.alertCancel".localized, style: .Default) { (action:UIAlertAction!) in
                self.isPresentedErrorAlert = false
                return
            }
            errorAlert.addAction(cancelAction)
            self.presentViewController(errorAlert, animated: true, completion:nil)
        }
    }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.merchantIDField {
            self.passwordField.becomeFirstResponder()
        } else {
            onLogInTouch(self)
        }
        return true
    }
}