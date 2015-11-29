//
//  TimerDetailController.swift
//  Thyme
//
//  Created by Matt Nichols on 11/29/15.
//  Copyright © 2015 Matt Nichols. All rights reserved.
//

import UIKit

class TimerDetailController: UITableViewController {


    // MARK: UITableViewController

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // TODO
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCellWithIdentifier("SegmentCell", forIndexPath: indexPath)
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section != 0) {
            return nil
        } else {
            return NSBundle.mainBundle().loadNibNamed("TimerHeader", owner: self, options: nil)[0] as? UIView
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dummyView = NSBundle.mainBundle().loadNibNamed("TimerHeader", owner: self, options: nil)[0] as! UIView
        dummyView.sizeToFit()
        return dummyView.frame.height
    }
}
