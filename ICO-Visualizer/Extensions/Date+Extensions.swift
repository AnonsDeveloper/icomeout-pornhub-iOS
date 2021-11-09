//
//  Date+Extensions.swift
//  ICO-visualizer
//
//  Created by Anonymous on 09/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current) + " ago"
    }
    
    func localTime() -> Date {
         let timezone = TimeZone.current
         let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
         return Date(timeInterval: seconds, since: self)
     }
}
