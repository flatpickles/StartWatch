//
//  ThymeTimer.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import Foundation

enum ThymeState {
    case Unstarted, Started, Paused
}

struct ThymeSegment {
    let creationDate: NSDate
    var lastStarted: NSDate? = nil // if `nil`, segment is paused
    var duration: NSTimeInterval = 0

    init() {
        self.creationDate = NSDate()
    }

    init(creationDate: NSDate, duration: NSTimeInterval) {
        self.creationDate = creationDate
        self.duration = duration
    }
}

class ThymeTimer {
    var name: String
    var pastSegments: [ThymeSegment]?
    var currentSegment: ThymeSegment?

    var currentSegmentDuration: NSTimeInterval? {
        if let currentSegment = self.currentSegment {
            return currentSegment.duration - (currentSegment.lastStarted?.timeIntervalSinceNow ?? 0)
        } else {
            return nil
        }
    }

    var state: ThymeState {
        if (self.currentSegment?.lastStarted != nil) {
            return .Started
        } else if (self.currentSegment != nil) {
            return .Paused
        } else {
            return .Unstarted
        }
    }

    init(name: String) {
        self.name = name
    }

    func durationWithin(intervalBeforeNow: NSTimeInterval) -> NSTimeInterval {
        let dateTime = NSDate(timeIntervalSinceNow: -intervalBeforeNow)
        let pastDuration = self.pastSegments?.reduce(0, combine: { (current: NSTimeInterval, nextSegment: ThymeSegment) -> NSTimeInterval in
            return (dateTime.compare(nextSegment.creationDate) == .OrderedDescending) ? current : current + (nextSegment.duration ?? 0)
        })
        return (self.currentSegmentDuration ?? 0) + (pastDuration ?? 0)
    }

    func finalizeCurrentSegment() -> Bool {
        guard var currentSegment = self.currentSegment else {
            return false
        }

        currentSegment.duration -= ceil((currentSegment.lastStarted ?? NSDate()).timeIntervalSinceNow)
        currentSegment.lastStarted = nil

        self.pastSegments = self.pastSegments ?? []
        self.pastSegments?.insert(currentSegment, atIndex: 0)
        self.currentSegment = nil

        return true
    }

    class func debugTimer() -> ThymeTimer {
        let newTimer = ThymeTimer(name: "Debug Timer")
        newTimer.pastSegments = [ThymeSegment(creationDate: NSDate(timeIntervalSinceNow: -1000000), duration: 100), ThymeSegment(creationDate: NSDate(timeIntervalSinceNow: -20000000), duration: 200), ThymeSegment(creationDate: NSDate(timeIntervalSinceNow: -30000000), duration: 100)]
        return newTimer
    }
}
