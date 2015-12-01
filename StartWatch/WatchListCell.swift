//
//  WatchListCell.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class WatchListCell: UITableViewCell {
    @IBOutlet private weak var watchNameLabel: UILabel!
    @IBOutlet private weak var watchDurationLabel: UILabel!

    var name: String? {
        didSet {
            self.watchNameLabel.text = name
        }
    }

    var duration: NSTimeInterval? {
        didSet {
            let durationOrZero = duration ?? NSTimeInterval(0)
            self.watchDurationLabel.text = String(format: TimePassedCopyFormats[PreferredTimePassedInterval]!, durationOrZero.toString())
        }
    }

}
