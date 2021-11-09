//
//  UIView+Extensions.swift
//  Crypto Bot
//
//  Created by Anonymous on 21/09/21.
//

import UIKit

extension UIView {
    class var className: String {
        return String(describing: self)
    }
    
    func setShadowAndCorner(cornerRadius: CGFloat){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = cornerRadius
    }
    
    func calculateLabelHeightForText(text:String, font:UIFont, width:CGFloat) -> CGFloat{
       let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
       label.numberOfLines = 0
       label.lineBreakMode = NSLineBreakMode.byWordWrapping
       label.font = font
       label.text = text

       label.sizeToFit()
       return label.frame.height
   }
}

extension Optional where Wrapped == String {
    var nilOrEmpty: Bool {
        if self == nil {
            return true
        }
        if self == ""{
            return true
        }
        return false
    }
}
