//
//  StartWatch.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import Foundation

enum StartWatchState {
    case Unstarted, Started, Paused
}

class StartWatchSegment : NSObject, NSCoding {
    let creationDate: NSDate
    var lastStarted: NSDate? = nil // if `nil`, segment is paused
    var duration: NSTimeInterval = 0

    override init() {
        self.creationDate = NSDate()
        super.init()
    }

    init(creationDate: NSDate, duration: NSTimeInterval, lastStarted: NSDate?) {
        self.creationDate = creationDate
        self.lastStarted = lastStarted
        self.duration = duration
        super.init()
    }

    // MARK: NSCoding

    required convenience init?(coder aDecoder: NSCoder) {
        guard let creationDate = aDecoder.decodeObjectForKey("creationDate") as? NSDate,
            let duration = aDecoder.decodeObjectForKey("duration") as? NSTimeInterval else {
                return nil
        }
        let lastStarted = aDecoder.decodeObjectForKey("lastStarted") as? NSDate

        self.init(creationDate: creationDate, duration: duration, lastStarted: lastStarted)
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.creationDate, forKey: "creationDate")
        aCoder.encodeObject(self.lastStarted, forKey: "lastStarted")
        aCoder.encodeObject(self.duration, forKey: "duration")
    }
}

class StartWatch : NSObject, NSCoding {
    var name: String
    var pastSegments: [StartWatchSegment]?
    var currentSegment: StartWatchSegment?

    var currentSegmentDuration: NSTimeInterval? {
        if let currentSegment = self.currentSegment {
            return currentSegment.duration - (currentSegment.lastStarted?.timeIntervalSinceNow ?? 0)
        } else {
            return nil
        }
    }

    var state: StartWatchState {
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
        super.init()
    }

    init(name: String, pastSegments: [StartWatchSegment]?, currentSegment: StartWatchSegment?) {
        self.name = name
        self.pastSegments = pastSegments
        self.currentSegment = currentSegment
        super.init()
    }

    func durationWithin(intervalBeforeNow: NSTimeInterval) -> NSTimeInterval {
        let dateTime = NSDate(timeIntervalSinceNow: -intervalBeforeNow)
        let pastDuration = self.pastSegments?.reduce(0, combine: { (current: NSTimeInterval, nextSegment: StartWatchSegment) -> NSTimeInterval in
            return (dateTime.compare(nextSegment.creationDate) == .OrderedDescending) ? current : current + (nextSegment.duration ?? 0)
        })
        return (self.currentSegmentDuration ?? 0) + (pastDuration ?? 0)
    }

    func finalizeCurrentSegment() -> Bool {
        guard let currentSegment = self.currentSegment else {
            return false
        }

        currentSegment.duration -= ceil((currentSegment.lastStarted ?? NSDate()).timeIntervalSinceNow)
        currentSegment.lastStarted = nil

        self.pastSegments = self.pastSegments ?? []
        self.pastSegments?.insert(currentSegment, atIndex: 0)
        self.currentSegment = nil

        return true
    }

    class func debugTimer() -> StartWatch {
        let newTimer = StartWatch(name: "Debug Timer")
        newTimer.pastSegments = [StartWatchSegment(creationDate: NSDate(timeIntervalSinceNow: -1000000), duration: 100, lastStarted: nil), StartWatchSegment(creationDate: NSDate(timeIntervalSinceNow: -20000000), duration: 200, lastStarted: nil), StartWatchSegment(creationDate: NSDate(timeIntervalSinceNow: -30000000), duration: 100, lastStarted: nil)]
        return newTimer
    }

    // MARK: NSCoding

    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObjectForKey("name") as? String else {
            return nil
        }
        let pastSegments = aDecoder.decodeObjectForKey("pastSegments") as? [StartWatchSegment]
        let currentSegment = aDecoder.decodeObjectForKey("currentSegment") as? StartWatchSegment
        self.init(name: name, pastSegments: pastSegments, currentSegment: currentSegment)
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.pastSegments, forKey: "pastSegments")
        aCoder.encodeObject(self.currentSegment, forKey: "currentSegment")
    }
}
