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
    var countRequest = 3
    var isPresentedErrorAlert = false
    
    @IBOutlet weak var merchantIdLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var merchantIDField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var networkActivity: UIActivityIndicatorView!
    
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
        networkActivity.hidden = true
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
        
        networkActivity.hidden = false
        networkActivity.startAnimating()
        
        downloadTaxes()
        downloadDepartments()
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
        NetworkLoader.downloadTaxes({ taxes in
                TaxMethods().updateTaxes(taxes)
                self.countCompletedRequest += 1
                self.stopAnimateNetworkActivity()
            }, failure: {(code, message) in
                self.errorAlert(code, message: message)
        })
        
    }
    
    func downloadItems() {
        NetworkLoader.downloadItems({ items in
            InventoryListMethods.addInventoryFromResponse(items)
            self.countCompletedRequest += 1
            self.stopAnimateNetworkActivity()
            },
                                          failure: {(code, message) in
                                            self.errorAlert(code, message: message)
        })
    }
    
    func downloadDepartments() {
        NetworkLoader.downloadDepartments({ departments in
                DepartmentMethods().updateDepartments(departments)
                self.countCompletedRequest += 1
                self.stopAnimateNetworkActivity()
                self.downloadItems()
        },
              failure: {(code, message) in
                self.errorAlert(code, message: message)
        })
    }
    
    // MARK: - ActivityIndicator control
    
    func stopAnimateNetworkActivity() {
        if countCompletedRequest == countRequest {
            networkActivity.stopAnimating()
            self.performSegueWithIdentifier("showMenu", sender: self)
            self.navigationController?.navigationBarHidden = false
            countCompletedRequest = 0
        }
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