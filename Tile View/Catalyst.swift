//
//  Catalyst.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/5/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit


enum Catalyst {
    static var appKit: AppKit? {
        #if targetEnvironment(macCatalyst)
        guard let url = Bundle.main.builtInPlugInsURL?.appendingPathComponent("AppKitBridge.bundle") else {
            return nil
        }
        guard let bundle = Bundle(path: url.path) else { return nil }
        guard bundle.load() else { return nil }
        guard let cls = bundle.principalClass as? NSObject.Type else { return nil }
        guard let appKit = cls.init() as? AppKit else { return nil }
        return appKit
        #else
        return nil
        #endif
    }
}
