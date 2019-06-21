//
//  LoginVC.swift
//  MyProject
//
//  Created by Hailah on 20/06/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//


import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        userIntract(emailField: false, passwordField: false)
        let email = emailField.text?.trimmingCharacters(in: .whitespaces)
        let password = passwordField.text?.trimmingCharacters(in: .whitespaces)
        
        if  email!.isEmpty || password!.isEmpty {
            self.alertMessage(title: "Error", message: "email and password must not be empty")
            userIntract(emailField: true, passwordField: true)
        }else {
           API.postSession(with: email!, password: password!) { (result, error) in
            
                if let error = error {

                    self.alertMessage(title: "Error", message: error.localizedDescription )
                    self.userIntract(emailField: true, passwordField: true)
                    
                    return
                }
                if let error = result?["Error"] as? String {

                    self.alertMessage(title: "Error", message: error)
                    self.userIntract(emailField: true, passwordField: true)
                    
                    return
                }
                if let session = result?["session"] as? [String : Any], let sessionId = session["id"] as? String {
                    
                    print(sessionId)
                    DispatchQueue.main.async {
                        self.emailField.text = " "
                        self.passwordField.text = " "
                        self.performSegue(withIdentifier: "MapVC", sender: self)
                    }
                    
                    
                }
            }
        }
    }
    
    
    func userIntract(emailField : Bool , passwordField : Bool){
        
        DispatchQueue.main.async {
            self.emailField.isUserInteractionEnabled = emailField
            self.passwordField.isUserInteractionEnabled = passwordField
        }
    }
    
    
    
}
