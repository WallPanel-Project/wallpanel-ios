//
//  MQTTManager.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/10/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import CocoaMQTT

class MQTTManager : CocoaMQTTDelegate {
    
    //MARK: Private Variables
    private var myMqtt: CocoaMQTT = CocoaMQTT(clientID: "wallpanel")
    private var myLastError : String = ""
    private var didStart = false
    
    let wallPanel: WallPanelManager
    
    init(wallPanel: WallPanelManager) {
        self.wallPanel = wallPanel
        myMqtt.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMqtt() {
        if (wallPanel.config.mqttEnabled && !didStart) {
            loggingPrint("Starting MQTT")
            myMqtt.clientID = wallPanel.config.mqttClientId
            myMqtt.host = wallPanel.config.mqttHostname
            myMqtt.port = UInt16(wallPanel.config.mqttPort)
            if let username = wallPanel.config.mqttUsername {
                myMqtt.username = username
                myMqtt.password = wallPanel.config.mqttPassword
            }
            myMqtt.connect()
            didStart = true
            stateChanged()
        } else {
            loggingPrint("Not starting MQTT because it is not enabled")
        }
    }
    
    func restartMqtt() {
        loggingPrint("Restarting MQTT")
        if (didStart) { stopMqtt() }
        if (!didStart) { startMqtt() }
    }
    
    private func reconnectMqtt() {
        if (didStart) {
            loggingPrint("Reconnecting MQTT")
            myMqtt.connect()
            stateChanged()
        }
    }
    
    func stopMqtt() {
        if (didStart) {
            loggingPrint("Trying to disconnect MQTT")
            if (myMqtt.connState != CocoaMQTTConnState.disconnected) { myMqtt.disconnect() }
            didStart = false
            stateChanged()
        }
    }


    ///MQTT Functions
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        loggingPrint("MQTT Connected")
        myLastError = ""
        mqtt.subscribe("\(wallPanel.config.mqttBaseTopic)#")
        stateChanged()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        loggingPrint("MQTT Received Message: [\(message.topic)] \(message.string!)")
        if (message.topic == "\(wallPanel.config.mqttBaseTopic)command") {
            loggingPrint("Recognized as command message")
            if let json = try? JSONSerialization.jsonObject(
                with: (message.string ?? "").data(using: .utf8)!,
                options: []) as! [String:AnyObject] {
                if let url = json["url"] as? String {
                    wallPanel.browseUrl(url)
                    if let save = json["save"] as? Bool, save == true {
                        loggingPrint("... and will save!") //TODO
                    }
                }
                if let jsExec = json["jsExec"] as? String {
                    loggingPrint("Will jsExec \(jsExec)") //TODO
                }
                if let wakeup = json["wakeup"] as? Bool, wakeup == true {
                    loggingPrint("Will wake screen") //TODO
                }
                if let clearBrowserCache = json["clearBrowserCache"] as? Bool, clearBrowserCache == true {
                    loggingPrint("Will clear browser cache") //TODO
                }
                if let reload = json["reload"] as? Bool, reload == true {
                    wallPanel.reloadPage()
                }
            }
        }
        stateChanged()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        loggingPrint("MQTT Successfully subscribed to topic \(topic)")
        stateChanged()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        loggingPrint("MQTT Unsubscribed from topic \(topic)")
        stateChanged()
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        loggingPrint("MQTT Disconnected \(err.debugDescription)")
        
        myLastError = (err?.localizedDescription.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")) ?? ""

        stateChanged()
        
        let deadlineTime = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.reconnectMqtt()
        }
    }
    
    ///For Status View
    func stateChanged() {
        wallPanel.stateDelegate?.stateChanged()
    }
    
    var connectionState : String {
        if (wallPanel.config.mqttEnabled) {
            return String(describing: myMqtt.connState)
        } else {
            return "disabled"
        }
    }
    
    var lastError : String {
        return myLastError
    }
}
