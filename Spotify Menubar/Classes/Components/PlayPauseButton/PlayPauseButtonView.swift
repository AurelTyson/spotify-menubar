//
//  PlayPauseButtonView.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 29/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import FlatButton
import OGCircularBar
import RxCocoa
import RxSwift
import SnapKit

public final class PlayPauseButtonView: NSView {
    
    // MARK: Graphic attributes
    
    private var circularIndicator: OGCircularBarView!
    private var playButton: FlatButton!
    private var imageIcon: NSImageView!
    
    // MARK: Attributes
    
    public var progressValue: CGFloat? {
        get {
            return self.circularIndicator.bars.first?.progress
        }
        set {
            self.circularIndicator.bars.first?.animateProgress(newValue ?? 0, duration: 1)
        }
    }
    
    public var playAction: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view
        self.setupView()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view
        self.setupView()
        
    }
    
    private func setupView() {
        
        // Circular indicator
        self.circularIndicator = OGCircularBarView(frame: NSRect(x: 0, y: 0, width: 60, height: 60))
        self.circularIndicator.addBar(startAngle: 90,
                                      endAngle: -270,
                                      progress: 0,
                                      radius: 20,
                                      width: 2,
                                      color: NSColor.purple,
                                      animationDuration: 1,
                                      glowOpacity: 1,
                                      glowRadius: 4)
        self.circularIndicator.addBarBackground(startAngle: 90,
                                                endAngle: -270,
                                                radius: 20,
                                                width: 2,
                                                color: NSColor.purple.withAlphaComponent(0.2))
        
        // Play / pause button
        self.playButton = FlatButton()
        self.playButton.cornerRadius = 19
        self.playButton.title = ""
        self.playButton.buttonColor = .white
        self.playButton.borderColor = .clear
        self.playButton.rx.tap.subscribe(onNext: { [weak self] () in
            self?.playAction?()
        }).disposed(by: self.disposeBag)
        
        // Image
        self.imageIcon = NSImageView()
//        self.imageIcon.imageScaling = .scaleProportionallyUpOrDown
        
        // Adding subviews
        self.addSubview(self.circularIndicator)
        self.addSubview(self.playButton)
        self.addSubview(self.imageIcon)
        
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    public override func updateConstraints() {
        
        // Circular indicator
        self.circularIndicator.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        // Play / pause button
        self.playButton.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.circularIndicator.snp.center)
            make.width.equalTo(38)
            make.height.equalTo(38)
        }
        
        // Icon
        self.imageIcon.snp.makeConstraints { (make) in
            make.center.equalTo(self.playButton.snp.center)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        // Call to super at the end (according to Apple)
        super.updateConstraints()
        
    }
    
    // MARK: Methods
    
    public func setPlaying(_ playing: Bool) {
        
        self.imageIcon.image = playing ? NSImage.Player.pause : NSImage.Player.play
         
    }
    
}
