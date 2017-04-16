//
//  ConfigChangeDelegate.swift
//  WallPanel for iOS
//
//  Created by Nick on 4/16/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation

protocol ConfigChangeDelegate: class {
    func mqttConfigChanged()
}
