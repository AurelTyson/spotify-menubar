//
//  MainController.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 27/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

public final class MainController {
    
    // MARK: Services
    
    private let spotifyService: SpotifyServiceProtocol
    
    // MARK: Attributes
    
    private var pausedIcon: String!
    private var titleFormat: String!
    
    private let spotifyController = SpotifyController.shared
    private let preferencesController = PreferencesViewController()
    private let popoverViewController = PopoverViewController()
    
    private var eventMonitor: EventMonitor!
    
    private let disposeBag = DisposeBag()
    
    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.rx.tap.subscribe(onNext: { [weak self] () in
            self?.showContextMenu()
        }).disposed(by: self.disposeBag)
        let options: NSEvent.EventTypeMask = [.leftMouseUp, .rightMouseUp]
        statusItem.button?.sendAction(on: NSEvent.EventTypeMask(rawValue: UInt64(Int(options.rawValue))))
        return statusItem
    }()
    
    lazy var statusMenu: NSMenu = {
        let rightClickMenu = NSMenu()
        
        rightClickMenu.addItem(ATMenuItem(title: "About", keyEquivalent: "", actionClosure: { [weak self] () in
            self?.showAbout()
        }))
        rightClickMenu.addItem(ATMenuItem(title: "Preferences", keyEquivalent: "", actionClosure: { [weak self] () in
            self?.showPreferences()
        }))
        rightClickMenu.addItem(NSMenuItem.separator())
        rightClickMenu.addItem(ATMenuItem(title: "Quit", keyEquivalent: "", actionClosure: { [weak self] () in
            self?.quit()
        }))
        return rightClickMenu
    }()
    
    private lazy var popover: NSPopover! = {
        let popover = NSPopover()
        popover.contentViewController = self.popoverViewController
        popover.animates = true
        popover.behavior = .transient
        return popover
    }()
    
    // MARK: Init
    
    public init(spotifyService: SpotifyServiceProtocol) {
        
        // Init
        self.spotifyService = spotifyService
        
    }
    
    // MARK: Methods
    
    public func load() {
        
//        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notify), name: "com.spotify.client.PlaybackStateChanged", object: nil)
//        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(toggleDark), name: "AppleInterfaceThemeChangedNotification", object: nil)
//        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateIconImage), name: "com.elken.SpotifyTicker.updateIcon", object: nil)
//        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateFormat), name: "com.elken.SpotifyTicker.updateFormat", object: nil)
        
//        toggleDark()
//        updateIconImage()
//        updateFormat()
//        updateTrackInfo()
        
        // Event monitor
        self.eventMonitor = EventMonitor(mask: .leftMouseDown) { [weak self] event in
            if self?.popover.isShown == true {
                self?.closePopover()
            }
        }
        
        self.eventMonitor.start()
        
        // Status bar item configuration
        let lFont = NSFont(name: "Avenir-Light", size: 9)
        let lParagraphStyle = NSMutableParagraphStyle()
        lParagraphStyle.minimumLineHeight = 9
        lParagraphStyle.maximumLineHeight = 9
        lParagraphStyle.alignment = .left
        let lAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : lFont as Any,
                                                          NSAttributedStringKey.paragraphStyle : lParagraphStyle]
        let lAttributedTitle = NSAttributedString(string: "...", attributes: lAttributes)
        self.statusItem.button?.attributedTitle = lAttributedTitle
        self.statusItem.button?.setBoundsOrigin(NSPoint(x: 0, y: -3))
        
        // Observing current track
        self.spotifyService.currentTrack
            .subscribe(onNext: { [weak self] (track: SpotifyTrack) in
            
            // Updating menu bar
            self?.updateMenubar(with: track)
            
        }).disposed(by: self.disposeBag)
        
    }
    
    // MARK: Methods - private
    
    private func showPreferences() {
        self.preferencesController.title = "Preferences"
        self.preferencesController.presentViewControllerAsModalWindow(self.preferencesController)
    }
    
    private func showAbout() {
        let aboutController = AboutViewController()
        aboutController.title = "About"
        aboutController.presentViewControllerAsModalWindow(aboutController)
    }
    
    private func quit() {
        
        // Removing notifications observers
        DistributedNotificationCenter.default().removeObserver(self)
        
        // Stopping timer
        SpotifyService.shared.stopTimer()
        
        // Quit application
        NSApplication.shared.terminate(self)
        
    }
    
    private func showContextMenu() {
        guard let lCurrentEventType = NSApp.currentEvent?.type else {
            return
        }
        switch lCurrentEventType {
        case .rightMouseUp:
            self.statusItem.popUpMenu(self.statusMenu)
        default:
            togglePopover()
        }
    }
    
    private func togglePopover() {
        
        // Open / close popover
        self.popover.isShown ? self.closePopover() : self.showPopover()
        
    }
    
    func showPopover() {
        if let button = self.statusItem.button {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
        }
        self.eventMonitor.start()
    }
    
    func closePopover() {
        self.popover.performClose(nil)
        self.eventMonitor.stop()
    }
    
    private func updateMenubar(with track: SpotifyTrack) {
        
        // Tool tip
        self.statusItem.toolTip = "\(track.name ?? "...") - \(track.artist ?? "")"
        
        // Updating track name in status item
        let lAttributedTitle = NSMutableAttributedString(attributedString: self.statusItem.button!.attributedTitle)
        lAttributedTitle.mutableString.setString("\(track.name ?? "...")\n\(track.artist ?? "...")")
        self.statusItem.button?.attributedTitle = lAttributedTitle
        
    }
    
    // #####################
    
//    private func updateFormat() {
//        self.titleFormat = self.preferencesController.checkOrDefault(key: "titleFormat", def: "%a - %s (%p/%d)")
//    }
    
//    public func updateIconImage() {
//        if self.preferencesController.checkOrDefault(key: "showIcon", def: 1) == 1 {
//            statusItem.image = NSImage(named: NSImage.Name(rawValue: updateIcon()))
//        }
//        else {
//            statusItem.image = nil
//        }
//    }
    
//    func updateTitle(name: String) {
//        statusItem.title = name
//    }
    
//    func timeFormatted(totalSeconds: Int) -> String {
//        let seconds: Int = totalSeconds % 60
//        let minutes: Int = (totalSeconds / 60) % 60
//        let hours: Int = totalSeconds / 3600
//
//        return hours == 0 ? String(format: "%02d:%02d", minutes, seconds) : String(format: "%02d:%02d%02d", hours, minutes, seconds)
//    }
    
//    func updateIcon() -> String {
//        return (spotifyController.isPlaying() ? "spotify" : pausedIcon) as String
//    }
    
//    func notify() {
//        updateTrackInfo()
//    }
    
//    func updateTrackInfo() {
//        if spotifyController.isPlaying() {
//
//            let current = spotifyController.currentTrack()
//            let position = timeFormatted(totalSeconds: spotifyController.playerPosition())
//            let duration = timeFormatted(totalSeconds: (current.duration)! / 1000)
//            var format: String = titleFormat
//
//            let d: [String: String] = ["%a": "\(current.artist!)",
//                "%s": "\(current.name!)",
//                "%p": "\(position)",
//                "%d": "\(duration)"]
//
//            for (key, value) in d {
//                if format.contains(key) {
//                    //                    if value.count >= 20 {
//                    //                        format = format.replacingOccurrences(of: key, with: "\(value.substring(to: value.startIndex.advancedBy(20))) ...")
//                    //                    }
//                    format = format.replacingOccurrences(of: key, with: value)
//                }
//            }
//            updateTitle(name: format)
//        }
//        else {
//            statusItem.title = "▐▐ "
//        }
//    }
    
//    func toggleDark() {
//        pausedIcon = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark" ? "spotify-white" : "spotify-black"
//        updateIconImage()
//    }
    
}
