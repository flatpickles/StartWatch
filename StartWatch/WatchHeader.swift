//
//  WatchHeader.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

protocol WatchHeaderDelegate: class {
    func toggleHeaderState(header: WatchHeader)
    func headerShouldChangeCumulativeDisplay(header: WatchHeader)
    func headerShouldConfirm(header: WatchHeader)
}

class WatchHeader: UIView {
    weak var delegate: WatchHeaderDelegate?

    @IBOutlet weak var watchLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cumulativeTimeButton: UIButton! {
        didSet {
            self.cumulativeTimeButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.cumulativeTimeButton.titleLabel?.minimumScaleFactor = 0.5
        }
    }

    @IBAction func cumulativeTimeTapped(sender: AnyObject) {
        delegate?.headerShouldChangeCumulativeDisplay(self)
    }

    @IBAction func confirmTapped(sender: AnyObject) {
        delegate?.headerShouldConfirm(self)
    }

    @IBAction func startStopTapped(sender: AnyObject) {
        delegate?.toggleHeaderState(self)
    }
}
