//
//  TimerHeader.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

protocol TimerHeaderDelegate: class {
    func shouldChangeCumulativeDisplay()
    func shouldToggleState()
    func shouldConfirm()
}

class TimerHeader: UIView {
    weak var delegate: TimerHeaderDelegate?

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cumulativeTimeButton: UIButton!

    @IBAction func cumulativeTimeTapped(sender: AnyObject) {
        delegate?.shouldChangeCumulativeDisplay()
    }

    @IBAction func confirmTapped(sender: AnyObject) {
        delegate?.shouldConfirm()
    }

    @IBAction func startStopTapped(sender: AnyObject) {
        delegate?.shouldToggleState()
    }
}
