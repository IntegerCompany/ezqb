//
//  SignUpViewController.swift
//  EZQB
//
//  Created by iOS Developer on 7/22/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDelegate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Observers.addObservers(self,
            withshowKBString: "keyboardWillShow:",
            andhideKBString: "keyboardWillHide:"
        )
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.resignFirstResponderAllTextField()
        Observers.removeObservers(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - ButtonActions
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        
        if self.validate() == false {
            
            AlertView.showAlert(self,
                title: "Validation error",
                message: "Passwords don't match",
                buttonTitle: "OK"
            )
        } else {
            self.registerWithUserName()
        }
    }
    
    @IBAction func backToLogIn(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - ButtonAction's functions
    
    private func registerWithUserName () {
        
        self.disableButtons(false)
        self.activityIndicatorEnable(false)
        DataProvider.registerWithUserName(firstNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) {
            (response, error) -> Void in
            
            if error == nil
                &&
                response!.success {
                    
                    self.navigationController?.popViewControllerAnimated(true)
            } else {
                
                AlertView.showAlert(self,
                    title: "Exception",
                    message: response!.error!,
                    buttonTitle: "OK"
                )
            }
            self.disableButtons(true)
            self.activityIndicatorEnable(true)
        }
    }
    
    private func validate() -> Bool {
        
        return self.passwordTextField.text == self.confirmPasswordTextField.text
    }
    
    
    // MARK: - enable / disable elements function
    
    private func activityIndicatorEnable(bool: Bool) {
        
        self.activityIndicator.hidden = bool
        bool ? self.activityIndicator.stopAnimating() :
            self.activityIndicator.startAnimating()
    }
    
    private func disableButtons(bool: Bool) {
        
        self.backButton.enabled = bool
        self.registerButton.enabled = bool
    }
    
    
    // MARK: - set delegate method
    
    private func setDelegate() {
        
        self.emailTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.resignFirstResponderAllTextField()
        
        return true
    }
    
    private func resignFirstResponderAllTextField() {
        
        self.emailTextField!.resignFirstResponder()
        self.firstNameTextField!.resignFirstResponder()
        self.lastNameTextField!.resignFirstResponder()
        self.passwordTextField!.resignFirstResponder()
        self.confirmPasswordTextField!.resignFirstResponder()
    }
    
    
    // MARK: - keyboard actions
    
    func keyboardWillShow(notification: NSNotification) {
        
        KeyboardActions.keyboardWillShow(notification,
            scrollViewBottomConstraint: self.scrollViewBottomConstraint,
            scrollView: scrollView
        )
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        KeyboardActions.keyboardWillHide(self.scrollViewBottomConstraint,
            scrollView: scrollView
        )
    }
    
    
    // MARK: - objection rotation in Landscape
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
