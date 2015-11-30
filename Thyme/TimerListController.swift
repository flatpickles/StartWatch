//
//  TimerListController.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class TimerListController: UITableViewController {
    var timers: [ThymeTimer] = [ThymeTimer.debugTimer(), ThymeTimer.debugTimer(), ThymeTimer.debugTimer()]

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

            self.timers.insert(newTimer, atIndex: 0)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
        }))
        self.presentViewController(newTimerController, animated: true, completion: nil)
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // To update the duration copy on the cells
        self.tableView.reloadData()
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
        return timers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TimerListCell", forIndexPath: indexPath) as! TimerListCell
        let timer = self.timerForIndexPath(indexPath)
        cell.name = timer?.name
        cell.duration = timer?.durationWithin(TimePassedIntervals[PreferredTimePassedInterval]!)
        return cell
    }

    // MARK: Helpers

    private func timerForIndexPath(indexPath: NSIndexPath?) -> ThymeTimer? {
        if let path = indexPath {
            return self.timers[path.row]
        } else {
            return nil
        }
    }
}
