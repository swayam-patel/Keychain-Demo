//
//  ViewController.swift
//  Keychain-Demo
//
//  Created by Swayam Patel on 23/01/25.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var createLoginView: UIView!
    @IBOutlet weak var savedLoginView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    // MARK: Variables
    var securityKey = "login_data"
    
    // MARK: View Controller Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get data from Keychain
        let retrievedData = (KeychainManager.shared.retrieve(key: securityKey)) as Data
        
        print(retrievedData)
        if retrievedData.isEmpty {
            savedLoginView.isHidden = true
            createLoginView.isHidden = false

            return
        }
        
        // Convert Data() -> Original data
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: retrievedData, options: []) as? [String: Any] {
                print(jsonObject)
                // Parse the JSON object
                if let email = jsonObject["email"] as? String, let password = jsonObject["password"] as? String {
                    loginLabel.text = "\(email)\n\(password)"
                    
                    emailTextField.text = email
                    passwordTextField.text = password
                    
                    savedLoginView.isHidden = false
                    createLoginView.isHidden = true
                }
            }
        } catch {
            showAlert(message: "Failed to deserialize data: \(error.localizedDescription)")
            savedLoginView.isHidden = true
            createLoginView.isHidden = false
        }
    }
    
    // MARK: Helper Methods
    func showAlert(message: String, title: String = "Keychain Demo") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func userHandleAction(sender:UIButton){
        if sender == saveButton {
            guard let email = emailTextField.text, !email.isEmpty else {
                showAlert(message: "Please enter an email")
                return
            }
            
            guard let password = passwordTextField.text, !password.isEmpty else {
                showAlert(message: "Please enter a password")
                return
            }
            
            // Send the details as Data()
            if let jsonData = try? JSONSerialization.data(withJSONObject:["email":email,"password":password]) {
                let success = KeychainManager.shared.save(key: self.securityKey, data: jsonData)
                if success {
                    showAlert(message: "Login saved successfully!")
                    savedLoginView.isHidden = false
                    createLoginView.isHidden = true
                    
                    loginLabel.text = "\(email)\n\(password)"
                } else {
                    showAlert(message: "Failed to save password")
                }
            } else {
                showAlert(message: "Something went wrong in conversion")
            }
        } else if sender == updateButton {
            savedLoginView.isHidden = true
            createLoginView.isHidden = false
        } else if sender == deleteButton {
            // Delete the key and the stored data
            let success = KeychainManager.shared.delete(key: securityKey)
            if success {
                showAlert(message: "Login deleted successfully!")
                loginLabel.text = ""
                emailTextField.text = ""
                passwordTextField.text = ""
                savedLoginView.isHidden = true
                createLoginView.isHidden = false
            } else {
                showAlert(message: "Failed to delete login")
            }
        }
    }
}
