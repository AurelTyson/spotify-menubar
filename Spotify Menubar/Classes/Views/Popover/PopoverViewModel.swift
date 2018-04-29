//
//  PopoverViewModel.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 27/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import Foundation
import RxCocoa
import RxSwift

public protocol PopoverViewModelType {
    
    var currentTrack: PublishRelay<SpotifyTrack> { get }
    var currentTrackImage: BehaviorRelay<NSImage?> { get }
    var currentPlayerPosition: CGFloat { get }
    var isPlayerPlaying: Bool { get }
    
    func didFire(playerAction: MusicPlayerAction)
    
}

public final class PopoverViewModel: PopoverViewModelType {
    
    // MARK: Services
    
    private let spotifyService: SpotifyServiceProtocol
    private let imageService: ImageServiceProtocol
    
    // MARK: Attributes
    
    public let currentTrack = PublishRelay<SpotifyTrack>()
    public let currentTrackImage = BehaviorRelay<NSImage?>(value: nil)
    public var currentPlayerPosition: CGFloat {
        return self.spotifyService.getCurrentPlayerPosition()
    }
    public var isPlayerPlaying: Bool {
        return self.spotifyService.isPlayerPlaying()
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    public init(spotifyService: SpotifyServiceProtocol,
                imageService: ImageServiceProtocol) {
        
        // Init
        self.spotifyService = spotifyService
        self.imageService = imageService
        
        // Subscribing to current track
        self.spotifyService.currentTrack.subscribe(onNext: { [weak self] (track: SpotifyTrack) in
            
            // Next track
            self?.currentTrack.accept(track)
            
        }).disposed(by: self.disposeBag)
        
        // Subscribing to current track image
        self.spotifyService.currentTrack
            .map({ $0.artworkUrl ?? "" })
            .distinctUntilChanged()
            .concatMap({ (url: String) -> Observable<NSImage?> in
                self.imageService.getImage(url: url)
            })
            .subscribe(onNext: { [weak self] (image: NSImage?) in
                
                self?.currentTrackImage.accept(image)
                
            }, onError: { (error: Error) in
                
            })
            .disposed(by: self.disposeBag)
        
    }
    
    public func didFire(playerAction: MusicPlayerAction) {
        
        // Action
        self.spotifyService.didFire(playerAction: playerAction)
        
    }
    
}
