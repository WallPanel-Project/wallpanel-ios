//
//  WelcomeViewController.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/8/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import UIKit
import SideMenu

class DashboardViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var webView: UIDashboardWebView!
    
    let wallPanel: WallPanelManager
    
    init(wallPanel: WallPanelManager) {
        self.wallPanel = wallPanel
        self.webView = wallPanel.dashboardView
        
        super.init(nibName: nil, bundle: nil)
        view.addSubview(webView)
        view.autoresizesSubviews = true
        webView.frame = view.frame
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (!wallPanel.config.sidebarDisabled) {
            let menuRightNavigationController = RightNavigationController(wallPanel: wallPanel)
            
            SideMenuManager.default.menuRightNavigationController = menuRightNavigationController
            SideMenuManager.default.menuAddPanGestureToPresent(toView: self.view)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.webView.scrollView)
            SideMenuManager.default.menuPresentMode = .menuSlideIn
            SideMenuManager.default.menuWidth = 300
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.browseUrl(wallPanel.config.launchUrl)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

