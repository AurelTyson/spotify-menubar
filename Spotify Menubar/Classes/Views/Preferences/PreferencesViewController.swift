//
//  PreferencesViewController.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 26/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

public final class PreferencesViewController: NSViewController {
    
    // MARK: Text
    
    fileprivate enum Text {
        
        fileprivate static let title = ""
        
    }
    
    // MARK: Constants
    
    // MARK: Graphic attributes
    
    @IBOutlet private weak var checkIsNotificationActivated: NSButton!
    
    // MARK: Attributes
    
    private var viewModel: PreferencesViewModelType!
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    public init(configurationService: ConfigurationServiceProtocol = ConfigurationService.shared) {
        super.init(nibName: NSNib.Name(rawValue: "PreferencesViewController"), bundle: nil)
        
        // ViewModel
        self.viewModel = PreferencesViewModel(configurationService: configurationService)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Is notification activated
        self.checkIsNotificationActivated.title = "Display notification when track is changing"
        self.checkIsNotificationActivated.rx.tap.subscribe(onNext: { [weak self] () in
            
            // Updating configuration
            let lIsChecked = self?.checkIsNotificationActivated.state == .on
            self?.viewModel.setNotificationActivated(lIsChecked)
            
        }).disposed(by: self.disposeBag)
        self.viewModel.isNotificationActivated.subscribe(onNext: { [weak self] (isActivated: Bool) in
            
            // Updating check
            self?.checkIsNotificationActivated.state = isActivated ? .on : .off
            
        }).disposed(by: self.disposeBag)
        
    }
    
}
