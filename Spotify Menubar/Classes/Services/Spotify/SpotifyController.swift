//
//  SpotifyController.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 27/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import ScriptingBridge

private let SPOTIFY_BUNDLE_ID = "com.spotify.client"

public final class SpotifyController {
    
    // MARK: Singleton
    
    public static let shared = SpotifyController()
    
    // MARK: Attributes
    
    private let spotifyInstance: SpotifyApplication = SBApplication(bundleIdentifier: SPOTIFY_BUNDLE_ID)!
    
    // MARK: Init
    
    private init() {
        
    }
    
    // MARK: Methods
    
    /**
     Toggle repeating on/off (currently doesn't handle "repeat one")
     */
    public func toggleRepeat() {
        self.spotifyInstance.setRepeating!(repeating: !self.spotifyInstance.repeating!)
    }
    
    public func toggleShuffle() {
        self.spotifyInstance.setShuffling!(shuffling: !self.spotifyInstance.shuffling!)
    }
    
    /**
     Check if repeating is on/off (currently doens't handle "repeat one")
     - returns: True/false for repeating status
     */
    public func isRepeating() -> Bool {
        return self.spotifyInstance.repeating!
    }
    
    public func isShuffling() -> Bool {
        return self.spotifyInstance.shuffling!
    }
    
    public func isPlaying() -> Bool {
        let state = self.spotifyInstance.playerState!
        return state == .playing
    }
    
    public func currentTrack() -> SpotifyTrack {
        return self.spotifyInstance.currentTrack!
    }
    
    public func playerPosition() -> Int {
        return Int(self.spotifyInstance.playerPosition!)
    }
    
    public func artworkURL() -> String {
        return self.spotifyInstance.currentTrack!.artworkUrl!
    }
    
    public func previousTrack() {
        self.spotifyInstance.previousTrack!()
    }
    
    public func nextTrack() {
        self.spotifyInstance.nextTrack!()
    }
    
    public func pause() {
        self.spotifyInstance.pause!()
    }
    
    public func play() {
        self.spotifyInstance.play!()
    }
    
    public func volume() -> Int {
        return self.spotifyInstance.soundVolume!
    }
    
    public func setVolume(volume: Int) {
        self.spotifyInstance.setSoundVolume!(soundVolume: volume)
    }
    
}
