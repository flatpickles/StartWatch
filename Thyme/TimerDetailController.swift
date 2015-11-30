//
//  TimerDetailController.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class TimerDetailController: UITableViewController, TimerHeaderDelegate {
    var timer: ThymeTimer? {
        didSet {
            self.title = timer?.name
            self.tableView.reloadData()
            self.updateNSTimerAndUI()
        }
    }

    private var header: TimerHeader? {
        didSet {
            self.updateNSTimerAndUI()
        }
    }
    private var updateTimer: NSTimer?

    // MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateNSTimerAndUI()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)

        self.updateTimer?.invalidate()
        self.updateTimer = nil
    }


    // MARK: UITableViewController

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timer?.pastSegments?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SegmentCell", forIndexPath: indexPath) as! TimerSegmentCell
        cell.segment = self.timer?.pastSegments?[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section != 0) {
            return nil
        } else {
            self.header = NSBundle.mainBundle().loadNibNamed("TimerHeader", owner: self, options: nil)[0] as? TimerHeader

            self.header?.delegate = self
            self.updateHeader()

            return self.header
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dummyView = NSBundle.mainBundle().loadNibNamed("TimerHeader", owner: self, options: nil)[0] as! UIView
        dummyView.sizeToFit()
        return dummyView.frame.height
    }

    // MARK: TimerHeaderDelegate

    func toggleHeaderState(header: TimerHeader) {
        if (self.timer?.state == .Started) {
            self.stopTimer()
        } else {
            self.startTimer()
        }
    }

    func headerShouldConfirm(header: TimerHeader) {
        // TODO
    }

    func headerShouldChangeCumulativeDisplay(header: TimerHeader) {
        // TODO
    }

    // MARK: Helpers

    private func startTimer() {
        if (self.timer?.currentSegment == nil) {
            self.timer?.currentSegment = ThymeSegment()
        }
        self.timer?.currentSegment?.lastStarted = NSDate()

        self.updateNSTimerAndUI()
    }

    private func stopTimer() {
        self.timer?.currentSegment?.duration -= (self.timer?.currentSegment?.lastStarted ?? NSDate()).timeIntervalSinceNow
        self.timer?.currentSegment?.lastStarted = nil

        self.updateNSTimerAndUI()
    }

    private func updateNSTimerAndUI() {
        UIView.setAnimationsEnabled(false)

        self.updateTimer?.invalidate()
        self.updateTimer = nil

        if (self.timer?.state == .Started) {
            // Start timer
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateHeader", userInfo: nil, repeats: true)

            // Update buttons
            self.header?.confirmButton.enabled = false
            self.header?.startStopButton.setTitle("Stop", forState: .Normal)
        } else if (self.timer?.state == .Paused) {
            self.header?.confirmButton.enabled = true
            self.header?.startStopButton.setTitle("Continue", forState: .Normal)
        } else {
            self.header?.confirmButton.enabled = false
            self.header?.startStopButton.setTitle("Start", forState: .Normal)
        }

        self.header?.startStopButton.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }

    func updateHeader() {
        guard let timer = self.timer else {
            return
        }

        self.header?.timerLabel.text = (timer.currentSegmentDuration ?? NSTimeInterval(0)).toString()
        UIView.setAnimationsEnabled(false)
        self.header?.cumulativeTimeButton.setTitle(String(format: AllTimeCopyFormat, timer.totalDuration.toString()), forState: .Normal)
        self.header?.cumulativeTimeButton.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}
