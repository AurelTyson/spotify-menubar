//
//  ConfigurationService.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 01/05/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

public enum ConfigurationKey: String {
    case isNotificationActivated = "isNotificationActivated"
}

public protocol ConfigurationServiceProtocol {
    
    func set(_ configurationKey: ConfigurationKey, to value: Any?)
    func get<U>(_ configurationKey: ConfigurationKey) -> U?
    
}

public final class ConfigurationService: ConfigurationServiceProtocol {
    
    // MARK: Singleton
    
    public static let shared: ConfigurationServiceProtocol = ConfigurationService()
    
    // MARK: Attributes
    
    private let userDefault = UserDefaults.standard
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    private init() {
        
    }
    
    // MARK: Methods
    
    public func set(_ configurationKey: ConfigurationKey, to value: Any?) {
        self.userDefault.set(value, forKey: configurationKey.rawValue)
    }
    
    public func get<U>(_ configurationKey: ConfigurationKey) -> U? {
        return self.userDefault.value(forKey: configurationKey.rawValue) as? U
    }
    
}
