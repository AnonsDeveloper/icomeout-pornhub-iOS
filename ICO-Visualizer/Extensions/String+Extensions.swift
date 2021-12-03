//
//  String+Extensions.swift
//  ICO-visualizer
//
//  Created by Anonymous on 09/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    func toDate() -> Date? {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterPrint.date(from: self)
    }
    
    func capturedGroups(withRegex pattern: String) -> [String] {
         var results = [String]()

         var regex: NSRegularExpression
         do {
             regex = try NSRegularExpression(pattern: pattern, options: [])
         } catch {
             return results
         }

         let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))

        for item in matches {
            let lastRangeIndex = item.numberOfRanges - 1
            guard lastRangeIndex >= 1 else { return results }

            for i in 0...lastRangeIndex {
                let capturedGroupIndex = item.range(at: i)
                if(capturedGroupIndex.length>0)
                {
                    let matchedString = (self as NSString).substring(with: capturedGroupIndex)
                    results.append(matchedString)
                }
            }
        }


         return results
     }
    
    func getQueryStringParameter(param: String) -> String? {
        guard let url = URLComponents(string: self) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func hexStringToUIColor () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
