//
//  WatchDetailController.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class WatchDetailController: UITableViewController, WatchHeaderDelegate {
    var watch: StartWatch? {
        didSet {
            self.title = watch?.name
            self.tableView.reloadData()
            self.updateNSTimerAndUI()
        }
    }

    private var header: WatchHeader? {
        didSet {
            self.updateNSTimerAndUI()
        }
    }
    private var updateTimer: NSTimer?
    private var currentTimePassedIntervalIndex: Int = 0

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
        return self.watch?.pastSegments?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SegmentCell", forIndexPath: indexPath) as! WatchSegmentCell
        cell.segment = self.watch?.pastSegments?[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section != 0) {
            return nil
        } else {
            self.header = NSBundle.mainBundle().loadNibNamed("WatchHeader", owner: self, options: nil)[0] as? WatchHeader

            self.header?.delegate = self
            self.updateHeader()

            return self.header
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dummyView = NSBundle.mainBundle().loadNibNamed("WatchHeader", owner: self, options: nil)[0] as! UIView
        dummyView.sizeToFit()
        return dummyView.frame.height
    }

    // MARK: TimerHeaderDelegate

    func toggleHeaderState(header: WatchHeader) {
        if (self.watch?.state == .Started) {
            self.stopWatch()
        } else {
            self.startWatch()
        }
    }

    func headerShouldConfirm(header: WatchHeader) {
        let didFinalize = self.watch?.finalizeCurrentSegment() ?? false
        StartWatchStore.saveWatches()

        self.updateNSTimerAndUI()
        self.updateHeader()

        if (didFinalize) {
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
        }
    }

    func headerShouldChangeCumulativeDisplay(header: WatchHeader) {
        PreferredTimePassedIntervalIndex = (PreferredTimePassedIntervalIndex + 1) % AllTimePassedOptions.count
        self.updateHeader()
    }

    // MARK: Helpers

    private func startWatch() {
        if (self.watch?.currentSegment == nil) {
            self.watch?.currentSegment = StartWatchSegment()
        }
        self.watch?.currentSegment?.lastStarted = NSDate()

        self.updateNSTimerAndUI()
        StartWatchStore.saveWatches()
    }

    private func stopWatch() {
        self.watch?.currentSegment?.duration -= ceil((self.watch?.currentSegment?.lastStarted ?? NSDate()).timeIntervalSinceNow)
        self.watch?.currentSegment?.lastStarted = nil

        if (self.watch?.currentSegment?.duration == 0) {
            self.watch?.currentSegment = nil
        }

        self.updateNSTimerAndUI()
        StartWatchStore.saveWatches()
    }

    private func updateNSTimerAndUI() {
        UIView.setAnimationsEnabled(false)

        self.updateTimer?.invalidate()
        self.updateTimer = nil

        if (self.watch?.state == .Started) {
            // Start timer
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateHeader", userInfo: nil, repeats: true)

            // Update buttons
            self.header?.confirmButton.enabled = false
            self.header?.startStopButton.setTitle("Stop", forState: .Normal)
        } else if (self.watch?.state == .Paused) {
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
        guard let watch = self.watch else {
            return
        }

        self.header?.watchLabel.text = (watch.currentSegmentDuration ?? NSTimeInterval(0)).toString()
        UIView.setAnimationsEnabled(false)
        self.header?.cumulativeTimeButton.setTitle(String(format: TimePassedCopyFormats[PreferredTimePassedInterval]!, watch.durationWithin(TimePassedIntervals[PreferredTimePassedInterval]!).toString()), forState: .Normal)
        self.header?.cumulativeTimeButton.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}
