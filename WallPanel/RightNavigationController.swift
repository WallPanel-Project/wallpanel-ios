//
//  RightNavigationViewController.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/15/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class RightNavigationController : UISideMenuNavigationController {
    
    let wallPanel : WallPanelManager
    
    init(wallPanel: WallPanelManager) {
        self.wallPanel = wallPanel
        super.init(nibName: nil, bundle: nil)
               
        let mainView = SidebarViewController(wallPanel: wallPanel)
        self.viewControllers = [mainView]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
