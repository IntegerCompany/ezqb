//
//  LoginViewController.swift
//  EZQB
//
//  Created by iOS Developer on 7/22/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userNameWithEmailTextField: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var reachability: Reachability?
    
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        view.addGestureRecognizer(tap)
        
        self.activityIndicator.hidesWhenStopped = true
        if Reachability.isConnectedToNetwork() == true {
            
//            println("\(reachability?.currentReachabilityStatus().value)")
            //
        } else {
            
            AlertView.showAlert(self,
                title: "Lost conection",
                message: "Please turn ON your Network",
                buttonTitle: "OK"
            )
        }
        
        self.setDelegates()
    }
    
    func hideKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let obj = Defaults.getEmailAndPassword() {
            self.userNameWithEmailTextField.text = obj.email
            self.passwordTextField.text = obj.password
        } else {
            self.userNameWithEmailTextField.text = ""
            self.passwordTextField.text = ""
        }
        
        Observers.addObservers(self,
            withshowKBString: "keyboardWillShow:",
            andhideKBString: "keyboardWillHide:"
        )
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        Observers.removeObservers(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Actions
    
    @IBAction func submitButtonClicked(sender: AnyObject) {
        
        loginWithEmail(self.userNameWithEmailTextField!.text!,
            andPassword: self.passwordTextField!.text!
        )
    }
    
    private func loginWithEmail(email: String, andPassword password: String) {
        
        self.disableButtons(false)
        self.isActivityIndicatorInAction(false)
        DataProvider.loginWithEmail(email,
            password: password) {
                (response, error) -> Void in
                if let requestOK = response {
                    if requestOK.success {
                        self.storeEmailAndPasswordIfNeed()
                        self.showUploadViewController()
                    }else{
                        AlertView.showAlert(self,
                            title: "Wrong login or password",
                            message: response!.error!,
                            buttonTitle: "OK")
                    }
                }else{
                    print("Login error")
                    dispatch_async(dispatch_get_main_queue(), {
                        AlertView.showAlert(self,
                            title: "Connection",
                            message: "Couldn't connecto to server",
                            buttonTitle: "OK")
                        self.disableButtons(true)
                        self.isActivityIndicatorInAction(true)
                    })
                }
                self.disableButtons(true)
                self.isActivityIndicatorInAction(true)
        }
    }
    
    private func storeEmailAndPasswordIfNeed() {
        
        if self.rememberMeSwitch.on {
            
            Defaults.setEmail(self.userNameWithEmailTextField.text!,
                andPassword: self.passwordTextField.text!
            )
        }
    }
    
    // MARK: - enable / disable elements function
    
    private func isActivityIndicatorInAction(bool: Bool) {
        if bool {
            self.activityIndicator.stopAnimating()
        }else{
            self.activityIndicator.startAnimating()
        }
//        self.activityIndicator.hidden = bool
//        bool ? self.activityIndicator.stopAnimating() :
//            self.activityIndicator.startAnimating()
    }
    
    private func disableButtons(bool: Bool) {
        
        self.logInButton.enabled = bool
        self.forgotPasswordButton.enabled = bool
        self.registerButton.enabled = bool
    }
    
    
    // MARK: - Navigation
    
    private func showUploadViewController() {
        self.performSegueWithIdentifier("UploadImageViewControllerSegue",
            sender: self
        )
        //romanso: you should not instantiate view controller from code
        // just call performSegueWithIdentifier ofr this purpose
        self.storyboard!.instantiateViewControllerWithIdentifier("UploadImageCVC") as! UploadImageCollectionViewController
         //romanso: this code should be in prepareForSegue when you get your
        // dastinationViewController from segue and take it to your custom view controller
        // and after that you should to set this property
    }
    
    // skatolyk: I can't do that because on the way there is navigationViewController!!!!
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "UploadImageViewControllerSegue" {
//            
//            var VC: UploadImageCollectionViewController = segue.destinationViewController as! UploadImageCollectionViewController
//            VC.userID = self.userNameWithEmailTextField.text
//        }
//    }
    
    
    // MARK: - UITextFieldDelegate
    
    private func setDelegates() {
        
        self.passwordTextField?.delegate = self
        self.userNameWithEmailTextField?.delegate = self
        self.scrollView.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.passwordTextField!.resignFirstResponder()
        self.userNameWithEmailTextField!.resignFirstResponder()
        
        return true
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

