//
//  SpotifyApplication.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 27/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import ScriptingBridge

/// Spotify playback statuses
@objc public enum SpotifyEPlS : AEKeyword {
    case stopped = 0x6b505353 /* 'kPSS' */
    case playing = 0x6b505350 /* 'kPSP' */
    case paused = 0x6b505370 /* 'kPSp' */
}

/// Wrapper for the Spotify Application itself
@objc public protocol SpotifyApplication: NSObjectProtocol {
    
    /// The current playing track.
    @objc optional var currentTrack: SpotifyTrack { get }
    
    /// The sound output volume (0 = minimum, 100 = maximum)
    @objc optional var soundVolume: Int { get }
    
    /// Is Spotify stopped, paused, or playing?
    @objc optional var playerState: SpotifyEPlS { get }
    
    /// The player’s position within the currently playing track in seconds.
    @objc optional var playerPosition: Double { get }
    
    /// Is repeating enabled in the current playback context?
    @objc optional var repeatingEnabled: Bool { get }
    
    /// Is repeating on or off?
    @objc optional var repeating: Bool { get }
    
    /// Is shuffling enabled in the current playback context?
    @objc optional var shufflingEnabled: Bool { get }
    
    /// Is shuffling on or off?
    @objc optional var shuffling: Bool { get }
    
    /// Skip to the next track.
    @objc optional func nextTrack()
    
    /// Skip to the previous track.
    @objc optional func previousTrack()
    
    /// Toggle play/pause.
    @objc optional func playpause()
    
    /// Pause playback.
    @objc optional func pause()
    
    /// Resume playback.
    @objc optional func play()
    
    /// Start playback of a track in the given context.
    @objc optional func playTrack(x: String!, inContext: String!)
    
    /// The sound output volume (0 = minimum, 100 = maximum)
    @objc optional func setSoundVolume(soundVolume: Int)
    
    /// The player’s position within the currently playing track in seconds.
    @objc optional func setPlayerPosition(playerPosition: Double)
    
    /// Is repeating on or off?
    @objc optional func setRepeating(repeating: Bool)
    
    /// Is shuffling on or off?
    @objc optional func setShuffling(shuffling: Bool)
    
    /// The name of the application.
    @objc optional var name: String { get }
    
    /// Is this the frontmost (active) application?
    @objc optional var frontmost: Bool { get }
    
    /// The version of the application.
    @objc optional var version: String { get }
    
}
extension SBApplication: SpotifyApplication {}
