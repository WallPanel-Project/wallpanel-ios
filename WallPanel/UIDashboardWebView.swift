//
//  UIDashboardWebView.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/16/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit

class UIDashboardWebView: UIWebView, UIWebViewDelegate {

    let wallPanel: WallPanelManager
    
    init(wallPanel : WallPanelManager)
    {
        self.wallPanel = wallPanel
        
        super.init(frame: CGRect(x:0, y:0, width:10, height:10))
        self.scrollView.bounces = false
        self.scalesPageToFit = true
        self.dataDetectorTypes = []
        
        self.delegate = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Disable user selection
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none'")
        // Disable callout
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none'")
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
