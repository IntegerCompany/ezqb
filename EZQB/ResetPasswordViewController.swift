//
//  ResetPasswordViewController.swift
//  EZQB
//
//  Created by iOS Developer on 7/28/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var alertView: AlertView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var userLoginTextField: UserLoginTextField!
    
    private var keyBoardHeight: CGFloat!
    
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDelegates()
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)

        self.addGestures()
        Observers.addObservers(self,
            withshowKBString: "keyboardWillShow:",
            andhideKBString: "keyboardWillHide:"
        )
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.userLoginTextField!.resignFirstResponder()
        Observers.removeObservers(self)
    }
    
    
    // MARK: - buttonClicked Actions
    
    @IBAction func backToLoginButtonClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetPasswordButtonClicked(sender: AnyObject) {
        
        DataProvider.resetPasswordWithEmail(self.userLoginTextField!.text!,
            completion: { (response, error) -> Void in
                
                if error == nil
                    &&
                    response!.success {
                        
                        AlertView.showAlert(self,
                            title: "Success",
                            message: "Please check your mail",
                            buttonTitle: "Ok"
                        )
                } else {
                    
                    AlertView.showAlert(self,
                        title: "Exception",
                        message: response!.error!,
                        buttonTitle: "Ok"
                    )
                }
        })
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.userLoginTextField!.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Gestures
    
    private func addGestures() {
        let gesture = UITapGestureRecognizer(target:self, action:Selector("backgroundViewTapped:"))
        self.backgroundView.addGestureRecognizer(gesture)
        self.backgroundView.userInteractionEnabled = true
    }
    
    func backgroundViewTapped(gesture: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - keyboard actions
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                
                self.keyBoardHeight = keyboardSize.height
                self.animateBackgroundViewUp(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateBackgroundViewUp(false)
    }
    

    // MARK: - animations
    
    private func animateBackgroundViewUp(up: Bool) {
        let movement = (up ? -keyBoardHeight : keyBoardHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement / 2.2)
        })
    }
    
    
    // MARK: - UITextFieldDelegate
    
    private func setDelegates() {

        self.userLoginTextField.delegate = self
    }
    
    
    // MARK: - objection rotation in Landscape
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
