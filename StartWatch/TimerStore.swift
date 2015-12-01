//
//  TimerStore.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import Foundation

class TimerStore {
    static var storedTimers: [ThymeTimer] = {
        // Initialize with stored timers
        return NSKeyedUnarchiver.unarchiveObjectWithFile(filename) as? [ThymeTimer] ?? []
    }()

    static func saveTimers() {
        // Save current storedTimers. Should be called whenever this is mutuated.
        NSKeyedArchiver.archiveRootObject(storedTimers, toFile: filename)
    }
}

private let filename = getDocumentsDirectory() + "/timers"
private func getDocumentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}