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
    
    private let configurationService: ConfigurationServiceProtocol
    private let spotifyService: SpotifyServiceProtocol
    
    // MARK: Attributes
    
    private var pausedIcon: String!
    private var titleFormat: String!
    
    private let spotifyController = SpotifyController.shared
    private let notificationCenter = NSUserNotificationCenter.default
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
    
    public init(configurationService: ConfigurationServiceProtocol,
                spotifyService: SpotifyServiceProtocol) {
        
        // Init
        self.configurationService = configurationService
        self.spotifyService = spotifyService
        
    }
    
    // MARK: Methods
    
    public func load() {
        
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
        
        // Observing track changes
        self.spotifyService.playbackStateChanged
            .subscribe(onNext: { [weak self] (track: SpotifyTrack?) in
                
                guard let lTrack = track else {
                    return
                }
                
                // Updating menu bar
                self?.updateMenubar(with: lTrack)
                
                // Displaying notification
                self?.displayNotification(with: lTrack)

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
    
    private func displayNotification(with track: SpotifyTrack) {
        
        // Check if notification is activated and player playing
        guard self.configurationService.get(.isNotificationActivated) == true,
            self.spotifyService.isPlayerPlaying() else {
            return
        }
        
        // Clear delivered notifications
        self.notificationCenter.removeAllDeliveredNotifications()
        
        // Notification
        let lNotification = NSUserNotification()
        lNotification.title = track.name ?? "..."
        lNotification.subtitle = track.artist ?? "..."
        lNotification.contentImage = NSImage(contentsOf: URL(string: track.artworkUrl ?? "")!)
        lNotification.deliveryDate = Date(timeIntervalSinceNow: 1)
        
        // Displaying notification
        self.notificationCenter.deliver(lNotification)
        
    }
    
}
