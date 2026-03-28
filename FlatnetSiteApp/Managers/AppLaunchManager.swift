//
//  AppLaunchManager.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 13.10.2025.
//

import Foundation


class AppLaunchManager {
    static func checkFirstLaunch() -> Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            return true // yeni kurulum
        }
        return false
    }
}
