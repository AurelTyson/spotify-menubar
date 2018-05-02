//
//  AboutViewController.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 26/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa

public final class AboutViewController: NSViewController {
    
    // MARK: Constants
    
    // MARK: Graphic attributes
    
    @IBOutlet private weak var labelAppName: NSTextField!
    @IBOutlet private weak var labelInfos: NSTextField!
    @IBOutlet private weak var labelGithub: NSTextField!
    @IBOutlet private weak var labelVersion: NSTextField!
    
    // MARK: Attributes
    
    // MARK: Init
    
    public init() {
        super.init(nibName: NSNib.Name(rawValue: "AboutViewController"), bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // The info dictionary
        let lInfoDict = Bundle.main.infoDictionary ?? [:]
        
        // App name
        let lAppName = lInfoDict["CFBundleExecutable"] as? String ?? "..."
        self.labelAppName.stringValue = lAppName
        
        // Infos
        self.labelInfos.stringValue = "Created by Aurel Tyson"
        
        // Github
        self.labelGithub.allowsEditingTextAttributes = true
        self.labelGithub.isEditable = false
        self.labelGithub.attributedStringValue = self.linkString(text: "Github repo", url: "https://github.com/AurelTyson/spotify-menubar")
        
        // Version
        let lAppVersion = lInfoDict["CFBundleShortVersionString"] as? String ?? "..."
        self.labelVersion.stringValue = "v\(lAppVersion)"
        
    }
    
    // MARK: Methods
    
    private func linkString(text: String, url: String) -> NSMutableAttributedString {
        
        // Initially set viewable text
        let lAttributedString = NSMutableAttributedString(string: text)
        let lRange = NSRange(location: 0, length: lAttributedString.length)
        
        // Stack URL
        lAttributedString.addAttribute(NSAttributedStringKey.link,
                                       value: NSURL(string: url)!,
                                       range: lRange)
        
        // Stack text color
        lAttributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                       value: NSColor.blue,
                                       range: lRange)
        
        return lAttributedString
        
    }
    
}
