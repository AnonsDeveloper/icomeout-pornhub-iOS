//
//  ToggleCollectionViewCell.swift
//  Crypto Bot
//
//  Created by Anonymous on 12/10/21.
//

import UIKit

class ToggleCollectionViewCell: FullWidthCollectionViewCell {
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    private var onSwitchStateChanged: ((Bool) -> Void)?
    
    func setup(title: String, isOn: Bool, onSwitchStateChanged: ((Bool) -> Void)?){
        self.titleView.text = title
        self.onSwitchStateChanged = onSwitchStateChanged
        self.switchView.setOn(isOn, animated: false)
    }
    
    @IBAction func onSwitchChanged(_ sender: UISwitch) {
        onSwitchStateChanged?(sender.isOn)
    }
}
