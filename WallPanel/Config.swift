//
//  Config.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/11/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation

class Config : NSObject {
    
    static let DEFAULT_LAUNCHURL = "https://wallpanel-project.github.io/app-launchurl"
    static let DEFAULT_MQTTHOSTNAME = "mqtt"
    static let DEFAULT_MQTTPORT = 1883
    static let DEFAULT_MQTTCLIENTID = "wallpanel"
    static let DEFAULT_MQTTBASETOPIC = "wallpanel/"
    
    weak var changeDelegate: ConfigChangeDelegate?
    
    override init() {
        super.init()
        
        UserDefaults.standard.register(defaults: [String : Any]())
        loadUserDefaults()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.defaultsChanged(notification:)),
                                               name: UserDefaults.didChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Properties
    private var _launchUrl: String = ""
    var launchUrl: String {
        get { return _launchUrl == "" ? Config.DEFAULT_LAUNCHURL : _launchUrl }
    }
    
    private var _sidebarDisabled: Bool = false
    var sidebarDisabled: Bool {
        get { return _sidebarDisabled }
    }
    
    private var _mqttEnabled: Bool = false
    var mqttEnabled: Bool {
        get { return _mqttEnabled }
    }
    
    private var _mqttHostname: String = ""
    var mqttHostname: String {
        get { return _mqttHostname == "" ? Config.DEFAULT_MQTTHOSTNAME : _mqttHostname }
    }
    
    private var _mqttPort: Int = 0
    var mqttPort: Int {
        get { return _mqttPort <= 0 ? Config.DEFAULT_MQTTPORT : _mqttPort }
    }
    
    private var _mqttClientId: String = ""
    var mqttClientId: String {
        get { return _mqttClientId == "" ? Config.DEFAULT_MQTTCLIENTID : _mqttClientId }
    }
    
    private var _mqttUsername: String?
    var mqttUsername : String? {
        get { return _mqttUsername }
    }
    
    private var _mqttPassword: String?
    var mqttPassword : String? {
        get { return _mqttPassword }
    }
    
    private var _mqttBaseTopic: String = ""
    var mqttBaseTopic : String {
        get { return _mqttBaseTopic == "" ?
                    Config.DEFAULT_MQTTBASETOPIC :
                    _mqttBaseTopic.hasSuffix("/") ? _mqttBaseTopic : "\(_mqttBaseTopic)/"
            }
    }
    
    //MARK: Functions
    func loadMqtt(enabled: Bool, hostname: String, port: Int, clientId: String, username: String?, password: String?, baseTopic: String)
    {
        var changed = false
        if (_mqttEnabled != enabled) { _mqttEnabled = enabled; changed = true}
        if (_mqttHostname != hostname) { _mqttHostname = hostname; changed = true }
        if (_mqttPort != port) { _mqttPort = port; changed = true }
        if (_mqttClientId != clientId) { _mqttClientId = clientId; changed = true }
        if (_mqttUsername != username) { _mqttUsername = username; changed = true }
        if (_mqttPassword != password) { _mqttPassword = password; changed = true }
        if (_mqttBaseTopic != baseTopic) { _mqttBaseTopic = baseTopic; changed = true }
        if (changed) {
            loggingPrint("MQTT Settings Changed")
            changeDelegate?.mqttConfigChanged()
        }
    }
    
    func loadUserDefaults() {
        _launchUrl = UserDefaults.standard.string(forKey: "launchurl") ?? ""
        _sidebarDisabled = UserDefaults.standard.bool(forKey: "sidebardisabled")
        
        loadMqtt(
            enabled: UserDefaults.standard.bool(forKey: "mqttenabled"),
            hostname: UserDefaults.standard.string(forKey: "mqtthostname") ?? "",
            port: UserDefaults.standard.integer(forKey: "mqttport"),
            clientId: UserDefaults.standard.string(forKey: "mqttclientid") ?? "",
            username: UserDefaults.standard.string(forKey: "mqttusername") ?? "",
            password: UserDefaults.standard.string(forKey: "mqttpassword") ?? "",
            baseTopic: UserDefaults.standard.string(forKey: "mqttbasetopic") ?? ""
        )
    }
    
    @objc func defaultsChanged(notification: Notification) {
        loggingPrint("User Defaults changed. Reloading them")
        loadUserDefaults()
    }
   
    
    
}
