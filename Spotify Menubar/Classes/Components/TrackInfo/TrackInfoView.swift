//
//  TrackInfoView.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 27/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import SnapKit

public final class TrackInfoView: NSView {
    
    // MARK: Graphic attributes
    
    private var labelTitle: NSTextField!
    private var labelValue: NSTextField!
    
    // MARK: Attributes
    
    public var title: String {
        get {
            return self.labelTitle.stringValue
        }
        set {
            self.labelTitle.stringValue = newValue
        }
    }
    
    public var value: String {
        get {
            return self.labelValue.stringValue
        }
        set {
            self.labelValue.stringValue = newValue
        }
    }
    
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
        
        // Title
        self.labelTitle = NSTextField(labelWithString: "Title")
        
        // Value
        self.labelValue = NSTextField(labelWithString: "Value\nValue\nValue")
        
        // Adding subviews
        self.addSubview(self.labelTitle)
        self.addSubview(self.labelValue)
        
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    public override func updateConstraints() {
        
        // Title
        self.labelTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.width.equalTo(60)
        }
        
        // Value
        self.labelValue.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.labelTitle.snp.right)
            make.right.equalTo(self.snp.right)
        }
        
        // Call to super at the end (according to Apple)
        super.updateConstraints()
        
    }
    
}
