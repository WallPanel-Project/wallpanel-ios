//
//  WebSidebarViewController.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/13/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit

class SidebarViewController : UIViewController, WallPanelStateDelegate {
    
    let wallPanel: WallPanelManager
    
    init(wallPanel: WallPanelManager) {
        self.wallPanel = wallPanel
        super.init(nibName: "SidebarView", bundle: nil)
        self.title = "WallPanel"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @IBAction func launchSettings(_ sender: Any) {
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(appSettings as URL)
        }
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        wallPanel.reloadPage()
    }
    
    @IBAction func relaunchButton(_ sender: Any) {
        wallPanel.relaunch()
    }
    
    ///MARK: Outlets
    @IBOutlet weak var labelConnected: UILabel!
    @IBOutlet weak var labelError: UILabel!
    
    override func viewDidLoad() {
        wallPanel.stateDelegate = self
        stateChanged()
    }
    
    /// WallPanelStateDelegate stuff
    func stateChanged() {
        labelConnected.text = wallPanel.mqttManager.connectionState
        labelError.text = wallPanel.mqttManager.lastError
    }
}
