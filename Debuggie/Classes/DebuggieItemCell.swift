//
//  DebuggerItemCell.swift
//  maarked
//
//  Created by Aleš Kocur on 29/05/16.
//  Copyright © 2016 FUNTASTY Digital s.r.o. All rights reserved.
//

import UIKit

class DebuggieItemCell: UITableViewCell {
    
    let availabilitySwitch = UISwitch()
    
    var availabilityDidChange: (Bool -> Void)?
    
    static let reuseIdentifier: String = "DebuggieItemCellIdentifier"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        availabilitySwitch.onTintColor = UIColor(red: 74.0 / 255.0, green: 200.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        
        accessoryView = availabilitySwitch
        availabilitySwitch.addTarget(self, action: #selector(DebuggieItemCell.availabilityChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    // MARK: - Events handling
    
    func availabilityChanged(sender: AnyObject?) {
        availabilityDidChange?(availabilitySwitch.on)
    }
}
