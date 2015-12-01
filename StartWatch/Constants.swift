//
//  Constants.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

// MARK: Time passed accounting (for displays like "00:45:23 in the past week")

enum TimePassed {
    case Epoch, Year, Month, Week, Day
}

let TimePassedCopyFormats: [TimePassed : String] = [
    .Epoch : "%@ all time",
    .Year : "%@ in the past year",
    .Month : "%@ in the past month",
    .Week : "%@ in the past week",
    .Day : "%@ in the past day"
]

let TimePassedIntervals: [TimePassed : NSTimeInterval] = [
    .Epoch : NSTimeIntervalSince1970,
    .Year : NSTimeInterval(60 * 60 * 24 * 365),
    .Month : NSTimeInterval(60 * 60 * 24 * 30),
    .Week : NSTimeInterval(60 * 60 * 24 * 7),
    .Day : NSTimeInterval(60 * 60 * 24)
]

// MARK: Preferred time passed stuff
// This is quick and dirty but it's probably fine. TODO: maybe clean this up.

let PreferredTimePassedIntervalKey = "PreferredTimePassedIntervalKey"
let AllTimePassedOptions: [TimePassed] = [.Epoch, .Year, .Month, .Week, .Day]
var PreferredTimePassedIntervalIndex: Int = NSUserDefaults.standardUserDefaults().integerForKey(PreferredTimePassedIntervalKey) {
    didSet {
        NSUserDefaults.standardUserDefaults().setInteger(PreferredTimePassedIntervalIndex, forKey: PreferredTimePassedIntervalKey)
    }
}
var PreferredTimePassedInterval: TimePassed {
    return AllTimePassedOptions[PreferredTimePassedIntervalIndex]
}
