//
//  SpotifyService.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 26/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import AppKit
import Cocoa
import RxCocoa
import RxSwift
import ScriptingBridge

public protocol SpotifyServiceProtocol {
    
    var currentTrack: PublishRelay<SpotifyTrack> { get }
    
    func stopTimer()
    func didFire(playerAction: MusicPlayerAction)
    func getCurrentPlayerPosition() -> CGFloat
    func isPlayerPlaying() -> Bool
    
}

public final class SpotifyService: SpotifyServiceProtocol {
    
    // MARK: Singleton
    
    public static let shared: SpotifyServiceProtocol = SpotifyService()
    
    // MARK: Attributes
    
    public let currentTrack = PublishRelay<SpotifyTrack>()
    
    private weak var timer: Timer!
    
    private let spotifyController = SpotifyController.shared
    
    // MARK: Init
    
    private init() {
        
        // Init
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(timerDidFire),
                                          userInfo: nil,
                                          repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
        
        // Start timer
        self.timer.fire()
        
    }
    
    // MARK: Methods
    
    public func stopTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    @objc func timerDidFire() {
        
        // Current track
        self.currentTrack.accept(self.spotifyController.currentTrack())
        
    }
    
    public func didFire(playerAction: MusicPlayerAction) {
        
        switch playerAction {
            
        case .playPause:
            self.spotifyController.isPlaying() ? self.spotifyController.pause() : self.spotifyController.play()
            
        case .previous:
            self.spotifyController.previousTrack()
            
        case .next:
            self.spotifyController.nextTrack()
            
        case .repeat:
            self.spotifyController.toggleRepeat()
            
        case .shuffle:
            self.spotifyController.toggleShuffle()
            
        }
        
    }
    
    public func getCurrentPlayerPosition() -> CGFloat {
        return CGFloat(self.spotifyController.playerPosition())
    }
    
    public func isPlayerPlaying() -> Bool {
        return self.spotifyController.isPlaying()
    }
    
}
