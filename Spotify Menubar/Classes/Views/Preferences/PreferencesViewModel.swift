//
//  PreferencesViewModel.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 01/05/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public protocol PreferencesViewModelType {
    
    var isNotificationActivated: BehaviorRelay<Bool> { get }
    
    func setNotificationActivated(_ activated: Bool)
    
}

public final class PreferencesViewModel: PreferencesViewModelType {
    
    // MARK: Services
    
    private let configurationService: ConfigurationServiceProtocol
    
    // MARK: Attributes
    
    public let isNotificationActivated = BehaviorRelay<Bool>(value: false)
    
    // MARK: Init
    
    public init(configurationService: ConfigurationServiceProtocol) {
        
        // Init
        self.configurationService = configurationService
        
        // Loading configuration
        let lIsNotificationActivated = self.configurationService.get(.isNotificationActivated) ?? false
        self.isNotificationActivated.accept(lIsNotificationActivated)
        
    }
    
    // MARK: Methods
    
    public func setNotificationActivated(_ activated: Bool) {
        
        // Update configuration
        self.configurationService.set(.isNotificationActivated, to: activated)
        
    }
    
}
