//
//  StartWatchStore.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import Foundation

class StartWatchStore {
    static var storedWatches: [StartWatch] = {
        // Initialize with stored timers
        return NSKeyedUnarchiver.unarchiveObjectWithFile(filename) as? [StartWatch] ?? []
    }()

    static func saveWatches() {
        // Save current storedTimers. Should be called whenever this is mutuated.
        NSKeyedArchiver.archiveRootObject(storedWatches, toFile: filename)
    }
}

private let filename = getDocumentsDirectory() + "/watches"
private func getDocumentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}