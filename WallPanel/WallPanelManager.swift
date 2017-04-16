//
//  CommandManager.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/11/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import AVFoundation

class WallPanelManager : ConfigChangeDelegate {
    
    //MARK: Public Variables
    let config : Config = Config()
    lazy private(set) var mqttManager : MQTTManager = { return MQTTManager(wallPanel: self) }()
    lazy private(set) var dashboardView : UIDashboardWebView = { return UIDashboardWebView(wallPanel: self) }()

    weak var stateDelegate: WallPanelStateDelegate?
    
    init() {
        config.changeDelegate = self
    }
    
    func start() {
        mqttManager.startMqtt()
    }
    
    func stop() {
        mqttManager.stopMqtt()
    }
    
    func browseUrl(_ url: String) {
        loggingPrint("Browsing to \(url)")
        dashboardView.browseUrl(url)
    }
    
    func reloadPage() {
        loggingPrint("Reloading current page")
        dashboardView.reloadPage()
    }

    func relaunch() {
        loggingPrint("Relaunching Dashboard")
        browseUrl(config.launchUrl)
    }
    
    /// Config Change Delegate
    func mqttConfigChanged() {
        mqttManager.restartMqtt()
    }
}

