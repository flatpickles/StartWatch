//
//  NSTimeInterval+StartWatch.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import Foundation

extension NSTimeInterval {
    func toString() -> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)

        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
}