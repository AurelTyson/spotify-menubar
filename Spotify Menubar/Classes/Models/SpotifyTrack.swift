//
//  SpotifyTrack.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 27/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import ScriptingBridge

/// Wrapper for the current track
@objc public protocol SpotifyTrack: NSObjectProtocol {
    
    /// The artist of the track.
    @objc optional var artist: String { get }
    
    /// The album of the track.
    @objc optional var album: String { get }
    
    /// The disc number of the track.
    @objc optional var discNumber: Int { get }
    
    /// The length of the track in seconds.
    @objc optional var duration: Int { get }
    
    /// The number of times this track has been played.
    @objc optional var playedCount: Int { get }
    
    /// The index of the track in its album.
    @objc optional var trackNumber: Int { get }
    
    /// Is the track starred?
    @objc optional var starred: Bool { get }
    
    /// How popular is this track? 0-100
    @objc optional var popularity: Int { get }
    
    /// The ID of the item.
    @objc optional func id() -> String
    
    /// The name of the track.
    @objc optional var name: String { get }
    
    /// The URL of the track's album cover.
    @objc optional var artworkUrl: String { get }
    
    /// That album artist of the track.
    @objc optional var albumArtist: String { get }
    
    /// The URL of the track.
    @objc optional var spotifyUrl: String { get }
    
    /// The URL of the track.
    @objc optional func setSpotifyUrl(spotifyUrl: String!)
    
}
extension SBObject: SpotifyTrack { }

extension SpotifyTrack {
    
}

public func == (lhs: SpotifyTrack, rhs: SpotifyTrack) -> Bool {
    return lhs.artist == rhs.artist &&
        lhs.name == rhs.name &&
        lhs.album == rhs.album
}
