//
//  WatchSegmentCell.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class WatchSegmentCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!

    var segment: StartWatchSegment? {
        didSet {
            guard let segment = self.segment else {
                return
            }

            self.durationLabel.text = (segment.duration ?? NSTimeInterval(0)).toString()

            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = NSDateFormatterStyle.NoStyle
            self.dateLabel.text = formatter.stringFromDate(segment.creationDate)
        }
    }

}
