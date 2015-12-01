//
//  WatchListController.swift
//  StartWatch
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class WatchListController: UITableViewController {
    private var updateTimer: NSTimer?

    @IBAction func newTimer(sender: AnyObject) {
        let newWatchController = UIAlertController(title: "New Watch", message: nil, preferredStyle: .Alert)
        var textField: UITextField?
        newWatchController.addTextFieldWithConfigurationHandler { (textFieldToConfigure: UITextField) -> Void in
            textField = textFieldToConfigure
        }
        newWatchController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        newWatchController.addAction(UIAlertAction(title: "Create", style: .Default, handler: { [unowned self] (_) -> Void in
            let newName = textField?.text ?? ""
            let newTimer = StartWatch(name: newName.isEmpty ? "New Watch" : newName)

            StartWatchStore.storedWatches.insert(newTimer, atIndex: 0)
            StartWatchStore.saveWatches()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)

            // TODO: bug – inserting sets the previous 0th row's duration to 00:00:00. Why??
        }))
        self.presentViewController(newWatchController, animated: true, completion: nil)
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
        if let controller = segue.destinationViewController as? WatchDetailController {
            if let watch = self.watchForIndexPath(self.tableView.indexPathForSelectedRow) {
                controller.watch = watch
            }
        }
    }

    // MARK: UITableViewController

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StartWatchStore.storedWatches.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("WatchListCell", forIndexPath: indexPath) as! WatchListCell
        let watch = self.watchForIndexPath(indexPath)
        cell.name = watch?.name
        cell.duration = watch?.durationWithin(TimePassedIntervals[PreferredTimePassedInterval]!)
        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.updateCumulativeDisplay(indexPath)
    }

    // MARK: Helpers

    private func watchForIndexPath(indexPath: NSIndexPath?) -> StartWatch? {
        if let path = indexPath {
            return StartWatchStore.storedWatches[path.row]
        } else {
            return nil
        }
    }

    private func updateCumulativeDisplay(indexPath: NSIndexPath) {
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? WatchListCell {
            let watch = self.watchForIndexPath(indexPath)
            cell.duration = watch?.durationWithin(TimePassedIntervals[PreferredTimePassedInterval]!)
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
