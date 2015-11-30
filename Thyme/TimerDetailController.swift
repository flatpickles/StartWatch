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

            // Reload to represent new timer
            self.tableView.reloadData()
        }
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
        guard let timer = self.timer else {
            return nil
        }

        if (section != 0) {
            return nil
        } else {
            let header = NSBundle.mainBundle().loadNibNamed("TimerHeader", owner: self, options: nil)[0] as? TimerHeader

            header?.delegate = self
            header?.timerLabel.text = (timer.currentSegmentDuration ?? NSTimeInterval(0)).toString()
            header?.cumulativeTimeButton.setTitle(String(format: AllTimeCopyFormat, timer.totalDuration.toString()), forState: .Normal)

            return header
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dummyView = NSBundle.mainBundle().loadNibNamed("TimerHeader", owner: self, options: nil)[0] as! UIView
        dummyView.sizeToFit()
        return dummyView.frame.height
    }

    // MARK: TimerHeaderDelegate

    func toggleHeaderState(header: TimerHeader) {
        // TODO
    }

    func headerShouldConfirm(header: TimerHeader) {
        // TODO
    }

    func headerShouldChangeCumulativeDisplay(header: TimerHeader) {
        // TODO
    }
}
