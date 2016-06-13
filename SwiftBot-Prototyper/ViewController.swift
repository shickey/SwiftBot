//
//  ViewController.swift
//  SwiftBot-Prototyper
//
//  Created by Sean Hickey on 6/12/16.
//
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        
    }
    
    override func viewDidAppear() {
        beginRendering(view.layer!, level: levels[0])
    }

}