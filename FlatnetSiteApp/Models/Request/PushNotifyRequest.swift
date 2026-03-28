//
//  PushNotifyRequest.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation

// MARK: - PushNotification
struct PushNotification: Codable {
    let platform, service, token: String
}
