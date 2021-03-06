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
    
    private let mainController = MainController(configurationService: ConfigurationService.shared,
                                                spotifyService: SpotifyService.shared)
    
    // MARK: Application delegate
    
    public func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Notification center delegate
        NSUserNotificationCenter.default.delegate = self
        
        // Loading app
        self.mainController.load()
        
    }
    
    public func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

extension AppDelegate: NSUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
}
