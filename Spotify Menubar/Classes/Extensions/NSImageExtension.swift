//
//  NSImageExtension.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 28/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa

public extension NSImage {
    
    public struct Menubar {
        
        public static let musicPlayer = NSImage(named: NSImage.Name("menubar_music_player"))
        
    }
    
    public struct Player {
        
        public static let pause = NSImage(named: NSImage.Name("player_pause"))
        public static let play = NSImage(named: NSImage.Name("player_play"))
        
    }
    
}
