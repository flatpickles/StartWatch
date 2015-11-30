//
//  TimerListController.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class TimerListController: UITableViewController {
    private var updateTimer: NSTimer?

    @IBAction func newTimer(sender: AnyObject) {
        let newTimerController = UIAlertController(title: "New Timer", message: nil, preferredStyle: .Alert)
        var textField: UITextField?
        newTimerController.addTextFieldWithConfigurationHandler { (textFieldToConfigure: UITextField) -> Void in
            textField = textFieldToConfigure
        }
        newTimerController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        newTimerController.addAction(UIAlertAction(title: "Create", style: .Default, handler: { [unowned self] (_) -> Void in
            let newName = textField?.text ?? ""
            let newTimer = ThymeTimer(name: newName.isEmpty ? "New Timer" : newName)

            TimerStore.storedTimers.insert(newTimer, atIndex: 0)
            TimerStore.saveTimers()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)

            // TODO: bug – inserting sets the previous 0th row's duration to 00:00:00. Why??
        }))
        self.presentViewController(newTimerController, animated: true, completion: nil)
    }

    // MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let row = self.tableView.indexPathForSelectedRow {
            // Deselect on e.g. bezel swipe back
            self.tableView.deselectRowAtIndexPath(row, animated: true)
        }

        // To update the duration copy on the cells
        self.updateVisibleCumulativeDisplays()

        // Start/restart the timer
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateVisibleCumulativeDisplays", userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.updateTimer?.invalidate()
        self.updateTimer = nil
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let controller = segue.destinationViewController as? TimerDetailController {
            if let timer = self.timerForIndexPath(self.tableView.indexPathForSelectedRow) {
                controller.timer = timer
            }
        }
    }

    // MARK: UITableViewController

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimerStore.storedTimers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TimerListCell", forIndexPath: indexPath) as! TimerListCell
        let timer = self.timerForIndexPath(indexPath)
        cell.name = timer?.name
        cell.duration = timer?.durationWithin(TimePassedIntervals[PreferredTimePassedInterval]!)
        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.updateCumulativeDisplay(indexPath)
    }

    // MARK: Helpers

    private func timerForIndexPath(indexPath: NSIndexPath?) -> ThymeTimer? {
        if let path = indexPath {
            return TimerStore.storedTimers[path.row]
        } else {
            return nil
        }
    }

    private func updateCumulativeDisplay(indexPath: NSIndexPath) {
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TimerListCell {
            let timer = self.timerForIndexPath(indexPath)
            cell.duration = timer?.durationWithin(TimePassedIntervals[PreferredTimePassedInterval]!)
        }
    }

    func updateVisibleCumulativeDisplays() {
        if let visiblePaths = self.tableView.indexPathsForVisibleRows {
            for path in visiblePaths {
                self.updateCumulativeDisplay(path)
            }
        }
    }
}
