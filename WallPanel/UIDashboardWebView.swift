//
//  UIDashboardWebView.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/16/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit

class UIDashboardWebView: UIWebView {

    let wallPanel: WallPanelManager
    
    init(wallPanel : WallPanelManager)
    {
        self.wallPanel = wallPanel
        
        super.init(frame: CGRect(x:0, y:0, width:10, height:10))
        self.scrollView.bounces = false
        self.scalesPageToFit = true
        self.dataDetectorTypes = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// For Dashboards
    func browseUrl(_ url: String) {
        let requestObj = URLRequest(url: URL(string: url)!)
        self.loadRequest(requestObj);
    }
    
    func reloadPage() {
        self.reload()
    }
}
