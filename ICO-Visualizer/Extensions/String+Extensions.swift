//
//  String+Extensions.swift
//  ICO-visualizer
//
//  Created by Anonymous on 09/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

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
        //2021-11-05 22:50:07
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

         //guard let match = matches.first else { return results }
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
}
