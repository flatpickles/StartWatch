//
//  ThymeTimer.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import Foundation

struct ThymeSegment {
    let start: NSDate
    var duration: NSTimeInterval? // if `nil`, segment is outstanding

    init() {
        self.start = NSDate()
    }

    init(start: NSDate, duration: NSTimeInterval) {
        self.start = start
        self.duration = duration
    }
}

class ThymeTimer {
    var name: String
    var pastSegments: [ThymeSegment]?
    var currentSegment: ThymeSegment?

    var currentSegmentDuration: NSTimeInterval? {
        if let currentSegment = self.currentSegment {
            return currentSegment.duration ?? -currentSegment.start.timeIntervalSinceNow
        } else {
            return nil
        }
    }

    var totalDuration: NSTimeInterval {
        let pastDuration = self.pastSegments?.reduce(0, combine: { (current: NSTimeInterval, nextSegment: ThymeSegment) -> NSTimeInterval in
            return current + (nextSegment.duration ?? 0)
        })
        return (self.currentSegmentDuration ?? 0) + (pastDuration ?? 0)
    }

    init(name: String) {
        self.name = name
    }

    class func debugTimer() -> ThymeTimer {
        let newTimer = ThymeTimer(name: "Debug Timer")
        newTimer.pastSegments = [ThymeSegment(start: NSDate(timeIntervalSinceNow: -1000), duration: 100), ThymeSegment(start: NSDate(timeIntervalSinceNow: -2000), duration: 200), ThymeSegment(start: NSDate(timeIntervalSinceNow: -3000), duration: 100)]
        return newTimer
    }
}
