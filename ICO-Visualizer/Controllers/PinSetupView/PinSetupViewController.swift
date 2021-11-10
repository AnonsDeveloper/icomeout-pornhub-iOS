//
//  PinSetupViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 06/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import SVPinView
import LocalAuthentication

class PinSetupViewController: UIViewController {
    
    public enum PinType {
        case newPin
        case auth
        case fakePin
    }
    
    let insertPinView: SVPinView = {
        let pinView = SVPinView()
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinView.pinLength = 4
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 5
        pinView.textColor = ColorLayout.default_text
        pinView.shouldSecureText = true
        pinView.style = .none
        pinView.fieldBackgroundColor = ColorLayout.default_tab_background
        pinView.fieldCornerRadius = 8
        pinView.activeFieldCornerRadius = 8
        pinView.activeFieldBackgroundColor = ColorLayout.default_grey
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 3

        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .phonePad
        pinView.keyboardAppearance = .default
        pinView.placeholder = "*****"
        pinView.becomeFirstResponderAtIndex = 0
        return pinView
    }()
    
    let pinConfirmView: SVPinView = {
        let pinView = SVPinView()
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinView.pinLength = 4
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 5
        pinView.textColor = ColorLayout.default_text
        pinView.shouldSecureText = true
        pinView.style = .none
        pinView.fieldBackgroundColor = ColorLayout.default_tab_background
        pinView.fieldCornerRadius = 8
        pinView.activeFieldCornerRadius = 8
        pinView.activeFieldBackgroundColor = ColorLayout.default_grey
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 3

        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .phonePad
        pinView.keyboardAppearance = .default
        pinView.placeholder = "*****"
        pinView.becomeFirstResponderAtIndex = 0
        return pinView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Please setup a secure PIN"
        label.textColor = ColorLayout.default_text
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = ""
        label.textColor = ColorLayout.default_text
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("    Confirm    ", for: .normal)
        button.backgroundColor = ColorLayout.default_orange
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var pinText: String?
    private var confirmPinText: String?
    
    public var pinType: PinType = .auth
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorLayout.default_background
        self.setupToHideKeyboardOnTapOnView()
        self.view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        
        
        self.view.addSubview(self.insertPinView)
        insertPinView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        insertPinView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 120).isActive = true
        
        self.view.addSubview(self.pinConfirmView)
        pinConfirmView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pinConfirmView.topAnchor.constraint(equalTo: self.insertPinView.bottomAnchor, constant: 20).isActive = true
        
        self.view.addSubview(self.saveButton)
        saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        saveButton.topAnchor.constraint(equalTo: self.pinConfirmView.bottomAnchor, constant: 40).isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2
            self.saveButton.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        }
        
        insertPinView.didFinishCallback = { [weak self] pin in
            self?.pinText = pin
            if self?.pinType == .auth {
                if self?.pinText == UserPreferences.shared.userPin {
                    NotificationCenter.default.post(name: .didEnterCorrectPin, object: nil)
                    self?.dismiss(animated: true, completion: nil)
                }
                else if self?.pinText == UserPreferences.shared.userFakePin {
                    NotificationCenter.default.post(name: .didEnterFakePin, object: nil)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        pinConfirmView.didFinishCallback = { [weak self] pin in
            self?.confirmPinText = pin
        }
        
        pinConfirmView.isHidden = !(pinType == .newPin || pinType == .fakePin)
        saveButton.isHidden = !(pinType == .newPin || pinType == .fakePin)
        self.titleLabel.text = pinType == .newPin ? "Please setup a secure PIN" : "Please insert your PIN"
        if self.pinType == .fakePin {
            self.titleLabel.text = "Setup your fake PIN"
            self.descriptionLabel.text = "When you digit a fake PIN in the PIN verification screen you will be redirect to a simple Pokemon list visualizer, just for protect you ;).\nBeware if you enable Face ID/Touch ID authentication this feature will be skipped"
        }
        
        if UserPreferences.shared.faceIdEnabled && pinType == .auth{
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            NotificationCenter.default.post(name: .didEnterCorrectPin, object: nil)
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else {
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let pinText = pinText, let confirmPinText = confirmPinText {
            if pinType == .newPin || pinType == .fakePin {
                if pinText == confirmPinText{
                    if self.pinType == .fakePin {
                        UserPreferences.shared.userFakePin = pinText
                    }
                    else{
                        UserPreferences.shared.userPin = pinText
                    }
                    
                    NotificationCenter.default.post(name: .didEnterCorrectPin, object: nil)
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    self.showError(message: "PINs do not match")
                }
            }
            else{
                if self.pinText == UserPreferences.shared.userPin {
                    NotificationCenter.default.post(name: .didEnterCorrectPin, object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else{
            self.showError(message: "Please insert a valid PIN")
        }
    }
    
    private func showError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
