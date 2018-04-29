//
//  PopoverViewController.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 26/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

public final class PopoverViewController: NSViewController {
    
    // MARK: Text
    
    fileprivate enum Text {
        
        fileprivate static let title = ""
        
    }
    
    // MARK: Constants
    
    // MARK: Graphic attributes
    
    @IBOutlet private weak var backgroundView: NSView!
    
    @IBOutlet private weak var imageViewArtwork: NSImageView!
    
    @IBOutlet private weak var labelSong: NSTextField!
    @IBOutlet private weak var labelArtist: NSTextField!
    
    @IBOutlet private weak var btnPlayPause: PlayPauseButtonView!
    
    // MARK: Attributes
    
    private var viewModel: PopoverViewModelType!
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    public init(spotifyService: SpotifyServiceProtocol = SpotifyService.shared,
                imageService: ImageServiceProtocol = ImageService.shared) {
        super.init(nibName: NSNib.Name(rawValue: "PopoverViewController"), bundle: nil)
        
        // ViewModel
        self.viewModel = PopoverViewModel(spotifyService: spotifyService,
                                          imageService: imageService)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Background
        self.backgroundView.wantsLayer = true
        self.backgroundView.layer?.backgroundColor = NSColor.white.cgColor
        
        // Song
        self.labelSong.stringValue = "..."
        self.labelSong.drawsBackground = true
        self.labelSong.backgroundColor = NSColor.clear
        
        // Artist
        self.labelArtist.stringValue = "..."
        self.labelArtist.drawsBackground = true
        self.labelArtist.backgroundColor = NSColor.clear
        
        // Play / pause button
        self.btnPlayPause.playAction = { [weak self] () in
            self?.viewModel.didFire(playerAction: .playPause)
        }
        
        // Binding current track
        self.viewModel.currentTrack.subscribe(onNext: { [weak self] (track: SpotifyTrack) in
            
            // Song
            self?.labelSong.stringValue = track.name ?? "..."
            
            // Artist
            self?.labelArtist.stringValue = track.artist ?? "..."
            
            // Progess
            let lPlayerPosition = self?.viewModel.currentPlayerPosition ?? 0
            let lTrackDuration = CGFloat(track.duration ?? 0) / 1000
            self?.btnPlayPause.progressValue = CGFloat(lPlayerPosition / lTrackDuration)
            
            // Playing / pause
            self?.btnPlayPause.setPlaying(self?.viewModel.isPlayerPlaying ?? false)
            
        }).disposed(by: self.disposeBag)
        
        // Binding image
        self.viewModel.currentTrackImage.subscribe(onNext: { [weak self] (image: NSImage?) in
            
            // Set image
            self?.imageViewArtwork.image = image
            
        }).disposed(by: self.disposeBag)
        
    }
    
}
