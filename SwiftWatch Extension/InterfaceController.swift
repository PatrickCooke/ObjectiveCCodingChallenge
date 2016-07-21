//
//  InterfaceController.swift
//  SwiftWatch Extension
//
//  Created by Patrick Cooke on 7/21/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import WatchKit
import Foundation



class InterfaceController: WKInterfaceController {

    @IBOutlet var colorDisplay: WKInterfaceGroup!
    @IBOutlet var colorlabel: WKInterfaceButton!
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        colorDisplay.setCornerRadius(self.contentFrame.width / 2)
        colorlabel.setBackgroundColor(UIColor.blueColor())
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
