//
//  TimerListCell.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class TimerListCell: UITableViewCell {
    @IBOutlet private weak var timerNameLabel: UILabel!
    @IBOutlet private weak var timerDurationLabel: UILabel!

    var name: String? {
        didSet {
            self.timerNameLabel.text = name
        }
    }

    var duration: NSTimeInterval? {
        didSet {
            let durationOrZero = duration ?? NSTimeInterval(0)
            self.timerDurationLabel.text = String(format: TimePassedCopyFormats[PreferredTimePassedInterval]!, durationOrZero.toString())
        }
    }

}
