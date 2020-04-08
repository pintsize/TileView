//
//  AppKitApp.swift
//  AppKitBridge
//
//  Created by Jacob Hazelgrove on 4/5/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Cocoa

class AppKitApp: NSObject, AppKit {

    
    func showColorPanel() {
        NSColorPanel.shared.orderFront(self)
    }
    
    func hideCursor() {
        NSCursor.hide()
    }
    
    func showCursor() {
        NSCursor.unhide()
    }
    
}
