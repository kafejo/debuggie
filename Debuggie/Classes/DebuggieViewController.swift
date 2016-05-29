//
//  DebuggerViewController.swift
//  maarked
//
//  Created by Aleš Kocur on 29/05/16.
//  Copyright © 2016 FUNTASTY Digital s.r.o. All rights reserved.
//

import UIKit

class DebuggieViewController: UITableViewController {
    
    var displayedItems: [Section]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Debuggie"
        tableView.registerClass(DebuggieItemCell.self, forCellReuseIdentifier: DebuggieItemCell.reuseIdentifier)
        tableView.registerClass(DebuggieNamespaceHeader.self, forHeaderFooterViewReuseIdentifier: DebuggieNamespaceHeader.reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        tableView.backgroundView = UIVisualEffectView(effect: UIBlurEffect())
        view.backgroundColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
        
        displayedItems = Debuggie.sharedDebugger.registations.keys.prepareForTable()
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
        return displayedItems.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems[section].items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DebuggieItemCell.reuseIdentifier, forIndexPath: indexPath)
        let key = displayedItems[indexPath.section][indexPath.row]
        
        if let cell = cell as? DebuggieItemCell {
            cell.textLabel?.text = key.name
            cell.availabilitySwitch.on = Debuggie.sharedDebugger.registations[key]!
            cell.availabilityDidChange = { change in
                Debuggie.sharedDebugger.registations[key] = change
            }
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(DebuggieNamespaceHeader.reuseIdentifier)
        
        let section = displayedItems[section]
        
        if let header = header as? DebuggieNamespaceHeader {
            header.textLabel?.text = section.name
        }
        
        return header
    }
}

class Section {
    let name: String
    let items: [NamespacedKey]
    
    subscript(index: Int) -> NamespacedKey {
        return items[index]
    }
    
    init(name: String, items: [NamespacedKey]) {
        self.name = name
        self.items = items
    }
}

extension SequenceType where Generator.Element == NamespacedKey {
    func prepareForTable() -> [Section] {
        let namespaces = map { $0.namespace }
        let uniqueSections = Array(Set(namespaces))
        
        return uniqueSections.sort(>).map { sn in
            let si = filter { $0.namespace == sn }
            return Section(name: sn, items: si)
        }
    }
}
