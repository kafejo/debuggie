//
//  ViewController.swift
//  Debuggie
//
//  Created by Aleš Kocur on 05/29/2016.
//  Copyright (c) 2016 Aleš Kocur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendRequest(sender: AnyObject) {
        outputLabel.text = TestService.testRequest()
    }
}

