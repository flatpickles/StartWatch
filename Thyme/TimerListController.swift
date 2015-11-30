//
//  TimerListController.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class TimerListController: UITableViewController {
    let timers: [ThymeTimer] = [ThymeTimer.debugTimer(), ThymeTimer.debugTimer(), ThymeTimer.debugTimer()]

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
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
        cell.duration = timer?.totalDuration
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
