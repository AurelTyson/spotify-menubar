//
//  PreferencesViewController.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 26/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    var prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func checkOrDefault<ReturnType>(key: String, def: Any?) -> ReturnType {
        if let val = prefs.value(forKey: key) {
            return val as! ReturnType
        }
        else {
            return def as! ReturnType
        }
    }
    
}
