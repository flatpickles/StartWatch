//
//  TimerHeader.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

protocol TimerHeaderDelegate: class {
    func toggleHeaderState(header: TimerHeader)
    func headerShouldChangeCumulativeDisplay(header: TimerHeader)
    func headerShouldConfirm(header: TimerHeader)
}

class TimerHeader: UIView {
    weak var delegate: TimerHeaderDelegate?

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cumulativeTimeButton: UIButton!

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
