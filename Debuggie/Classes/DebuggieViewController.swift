//
//  DebuggerViewController.swift
//  maarked
//
//  Created by Aleš Kocur on 29/05/16.
//  Copyright © 2016 FUNTASTY Digital s.r.o. All rights reserved.
//

import UIKit

class DebuggieViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Debuggie"
        tableView.registerClass(DebuggieItemCell.self, forCellReuseIdentifier: DebuggieItemCell.reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        tableView.backgroundView = UIVisualEffectView(effect: UIBlurEffect())
        view.backgroundColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        navigationController?.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 60.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Debuggie.sharedDebugger.registations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DebuggieItemCell.reuseIdentifier, forIndexPath: indexPath)
        let key = Debuggie.sharedDebugger.registations.keys.sort(>)[indexPath.row]
        
        if let cell = cell as? DebuggieItemCell {
            cell.textLabel?.text = key
            cell.availabilitySwitch.on = Debuggie.sharedDebugger.registations[key]!
            cell.availabilityDidChange = { change in
                Debuggie.sharedDebugger.registations[key] = change
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
