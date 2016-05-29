//
//  DebuggieNamespaceHeader.swift
//  Pods
//
//  Created by Aleš Kocur on 29/05/16.
//
//

import UIKit

class DebuggieNamespaceHeader: UITableViewHeaderFooterView {

    static let reuseIdentifier: String = "DebuggieNamespaceHeaderIdentifier"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
