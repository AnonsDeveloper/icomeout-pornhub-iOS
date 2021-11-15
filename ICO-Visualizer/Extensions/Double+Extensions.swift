//
//  Double+Extensions.swift
//  ICO-visualizer
//
//  Created by Anonymous on 09/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

extension Double {
    var shortStringRepresentation: String {
          if self.isNaN {
              return "NaN"
          }
          if self.isInfinite {
              return "\(self < 0.0 ? "-" : "+")Infinity"
          }
          let units = ["", "k", "M"]
          var interval = self
          var i = 0
          while i < units.count - 1 {
              if abs(interval) < 1000.0 {
                  break
              }
              i += 1
              interval /= 1000.0
          }
          // + 2 to have one digit after the comma, + 1 to not have any.
          // Remove the * and the number of digits argument to display all the digits after the comma.
        let val = log10(abs(interval))
        if val.isNaN || val.isInfinite {
            return "0"
        }
          return "\(String(format: "%0.*g", Int(val) + 2, interval))\(units[i])"
      }
}
