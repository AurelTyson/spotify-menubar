//
//  AppDelegate.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 26/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa

@NSApplicationMain
public final class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: Attributes
    
    private let mainController = MainController(spotifyService: SpotifyService.shared)
    
    // MARK: Application delegate
    
    public func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Loading app
        self.mainController.load()
        
    }
    
    public func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

