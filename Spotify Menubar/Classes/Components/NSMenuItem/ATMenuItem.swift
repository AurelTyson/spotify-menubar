//
//  ATMenuItem.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 27/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa

public final class ATMenuItem: NSMenuItem {
    
    // MARK: Attributes
    
    var actionClosure:() -> ()
    
    // MARK: Init
    
    public init(title: String, keyEquivalent: String, actionClosure: @escaping () -> ()) {
        self.actionClosure = actionClosure
        super.init(title: title, action: #selector(executeAction), keyEquivalent: keyEquivalent)
        self.target = self
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func executeAction(sender: NSMenuItem) {
        self.actionClosure()
    }
    
}
