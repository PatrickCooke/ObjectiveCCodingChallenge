//
//  InterfaceController.swift
//  SwiftWatch Extension
//
//  Created by Patrick Cooke on 7/21/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity



class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var colorDisplay: WKInterfaceGroup!
    @IBOutlet var colorlabel: WKInterfaceButton!
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        let newcolor = message["color"] as? String
        print(newcolor)
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            if newcolor!.containsString("blue") {
                self.colorlabel.setBackgroundColor(UIColor.blueColor())
            } else if newcolor!.containsString("green") {
                self.colorlabel.setBackgroundColor(UIColor.greenColor())
            } else if newcolor!.containsString("red") {
                self.colorlabel.setBackgroundColor(UIColor.redColor())
            } else if newcolor!.containsString("purple") {
                self.colorlabel.setBackgroundColor(UIColor.purpleColor())
            } else {
                self.colorlabel.setBackgroundColor(UIColor.blueColor())
            }
        }
        
    }
    
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
